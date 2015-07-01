module Console::ModelHelper
  include Console::UserManagerHelper

  def other_cartridges_link(has_suggestions, application)
    if has_suggestions
      link_to _("Or, see the entire list of cartridges you can add"), application_cartridge_types_path(application)
    else
      link_to _("Show other cartridges you can add to this application"), application_cartridge_types_path(application)
    end
  end

  def cartridge_info(cartridge, application)
    case
    when cartridge.jenkins_client?
      [
        link_to('configure', application_building_path(application), :title => _('Remove or change your Jenkins configuration')),
        "<span class=\"url\"><a href=\"#{application.build_job_url}\" target=\"_blank\" title=\"#{_("Go to Jenkins Build jobs")}\" class=\"font-icon-link\"><span class=\"font-icon url-icon\" aria-hidden=\"true\" data-icon=\"\ue002\"></span></a></span>"
      ].join(' ').html_safe
    when cartridge.haproxy_balancer?
      "<span class=\"url\"><a href=\"#{application.scale_status_url}\" target=\"_blank\" title=\"#{_("Go to HAProxy status page")}\" class=\"font-icon-link\"><span class=\"font-icon url-icon\" aria-hidden=\"true\" data-icon=\"\ue002\"></span></a></span>".html_safe
    when cartridge.database?
      name, _ = cartridge.data(:database_name)
      if name
        user, _ = cartridge.data(:username)
        password, _ = cartridge.data(:password)
        content_tag(:span,
          if user && password
            (@info_id ||= 0)
            link_id = "db_link_#{@info_id += 1}"
            span_id = "db_link_#{@info_id += 1}"
            "Database: <strong>#{h name}</strong> User: <strong>#{h user}</strong> Password: <strong><a href=\"javascript:;\" id=\"#{link_id}\" data-unhide=\"##{span_id}\" data-hide-parent=\"##{link_id}\">#{_("show")}</a><span id=\"#{span_id}\" class=\"hidden\"> #{h password}</span></strong>".html_safe
          else
            "Database: <strong>#{h name}</strong>"
          end
        )
      end
    else
      url, name = cartridge.data(:connection_url)
      if url
        "<span class=\"url\"><a href=\"#{url}\" target=\"_blank\" title=\"Go to #{h name}\" class=\"font-icon-link\"><span class=\"font-icon url-icon\" aria-hidden=\"true\" data-icon=\"\ue002\"></span></a></span>".html_safe
      end
    end
  end

  def gear_group_state(states)
    css_class = if states.all? {|s| s == :started}
        'state_started'
      elsif states.none? {|s| s == :started}
        'state_stopped'
      end

    content_tag(:span, gear_group_states(states), :class => css_class)
  end

  def gear_group_count(gears)
    types = gears.inject({}){ |h,g| h[g.gear_profile.to_s] ||= 0; h[g.gear_profile.to_s] += 1; h }
    return 'None' if types.empty?
    types.keys.sort.map do |k|
      "#{types[k]} #{k.humanize.downcase}"
    end.to_sentence
  end

  def available_gears_warning(writeable_domains)
    plan = user_manager_account_plan.content
    if plan[:status] == 'bt'
      return ("<a href='#{account_path}'>#{_('Click here')}</a> #{_('to validate your account in order to receive your credit.')}").html_safe
    end

    if writeable_domains.present?
      if !writeable_domains.find(&:allows_gears?)
        has_shared = writeable_domains.find {|d| !d.owner? }
        if has_shared
          _("The owners of the available domains have disabled all gear sizes from being created.")
        else
          _("You have disabled all gear sizes from being created.")
        end
      elsif !writeable_domains.find(&:has_available_gears?)
        if not plan[:payment][:valid]
          (_('There are no available gears.') + " <a href='#{account_path}'>" + _('Please, validate your account.') + '</a>.').html_safe
        else
          out_of_gears_message
        end
      end
    end
  end

  def out_of_gears_message
    _("There are not enough free gears available to create a new application. You will either need to scale down or delete existing applications to free up resources.")
  end

  def getup_gear_prices(currency=:BRL, ascending=true)
    user_manager_subscription_prices.content.select{ |item|
      item[:item] == "GEAR_USAGE" && ! item[:gear_size].empty? && item[:currency] == currency.to_s
    }.each{ |item|
      if item[:gear_size].start_with? 'small'
        item[:memory] = '512M'
        item[:storage] = '3G SSD'
      elsif item[:gear_size].start_with? 'medium'
        item[:memory] = '1G'
        item[:storage] = '6G SSD'
      else
        item[:memory] = ''
        item[:storage] = ''
      end
    }.sort!{ |a, b|
      if ascending
        a[:gear_size] <=> b[:gear_size]
      else
        b[:gear_size] <=> a[:gear_size]
      end
    }
  end
  def new_application_gear_sizes(writeable_domains, user_capabilities)
    gear_sizes = user_capabilities.allowed_gear_sizes
    if writeable_domains.present?
      gear_sizes = writeable_domains.map(&:capabilities).map(&:allowed_gear_sizes).flatten.uniq
    end
    gear_sizes
  end

  def add_cartridge_gear_sizes(application, cartridge_type, capabilities)
    gear_sizes = [application.gear_profile]
    if application.scales? && cartridge_type
      gear_estimate = gear_estimate_for_scaled_app({'1' => [cartridge_type]})
      increasing = (gear_estimate.begin > 0 || gear_estimate.end > 0)
      gear_sizes = capabilities.allowed_gear_sizes if increasing
    end
    gear_sizes
  end

  def estimate_domain_capabilities(selected_domain_name, writeable_domains, can_create, user_capabilities, user_usage_rates)
    if (selected_domain = writeable_domains.find {|d| d.name == selected_domain_name})
      [selected_domain.capabilities, selected_domain.usage_rates, selected_domain.owner?]
    elsif writeable_domains.length == 1
      [writeable_domains.first.capabilities, writeable_domains.first.usage_rates, writeable_domains.first.owner?]
    elsif can_create and writeable_domains.length == 0
      [user_capabilities, user_usage_rates, true]
    else
      [nil, nil, nil]
    end
  end

  def domains_for_select(domains)
    domains.sort_by(&:name).map do |d|
      capabilities = d.capabilities
      if capabilities
        [d.name, d.name, {
          "data-gear-sizes" => capabilities.allowed_gear_sizes.join(','),
          "data-gears-free" => capabilities.gears_free
        }]
      else
        [d.name, d.name]
      end
    end
  end

  def web_cartridge_scale_title(cartridge)
    if cartridge.current_scale == cartridge.scales_from
      _('Your web cartridge is running on the minimum amount of gears and will scale up if needed')
    elsif cartridge.current_scale == cartridge.scales_to
      _('Your web cartridge is running on the maximum amount of gears and cannot scale up any further')
    else
      _('Your web cartridge is running multiple copies to handle increased web traffic')
    end
  end

  def web_cartridge_scale_label(cartridge)
    suffix = case
      when cartridge.scales_from == cartridge.scales_to
      when cartridge.current_scale == cartridge.scales_from
        " (#{_('max')} #{cartridge.scales_to})"
      when cartridge.current_scale == cartridge.scales_to
        " (#{_('min')} #{cartridge.scales_from})"
      else
        " (#{_('min')} #{cartridge.scales_to}, #{_('max')} #{cartridge.scales_to})"
      end
    _("Routing to %s%s") % [pluralize(cartridge.current_scale, _('web gear')), suffix]
  end

  def application_gear_count(application)
    count = application.gear_count
    return _('no gears') if count == 0
    "#{count} #{application.gear_profile.to_s.humanize.downcase} #{count == 1 ? 'gear' : 'gears'}"
  end

  def cartridge_gear_group_count(group)
    return _('None') if group.gears.empty?
    "#{group.gears.length} #{group.gear_profile.to_s.humanize.downcase}"
  end

  def gear_group_count_title(total_gears)
    _("OpenShift runs each cartridge inside one or more gears on a server and is allocated a fixed portion of CPU time and memory use.")
  end

  def cartridge_storage(cart)
    storage_string(cart.total_storage)
  end

  def scaled_cartridge_storage(cart)
    storage_string(cart.total_storage, cart.current_scale)
  end

  def application_gear_title(application)
    count = application.gear_count
    if (scales = application.cartridges.select(&:scales?)) and scales.present?
      if scales.any?(&:has_scale_range?)
        if scales.none?(&:can_scale_up?)
          [:max, _("%s at maximum scale in this application.  Currently using %s.") % [pluralize(scales.count, _('cartridge')), application_gear_count(application)]]
        elsif scales.none?(&:can_scale_down?)
          [:min, _("%s at minimum scale in this application.  Currently using %s.") % [pluralize(scales.count, _('cartridge')), application_gear_count(application)]]
        else
          [:mid, _("%s above minimum scale in this application.  Currently using %s.") % [pluralize(scales.count, _('cartridge')), application_gear_count(application)]]
        end
      else
        [:fixed, _("This application is running at a fixed scale ratio, and is using %s.") % application_gear_count(application)]
      end
    else
      [nil, _("Unscaled application using %s") % application_gear_count(application)]
    end
  end

  def storage_string(quota,multiplier = 0)
    parts = []
    if multiplier > 1
      parts << "#{multiplier} x"
    end
    parts << "%s GB" % quota
    parts.join(' ').strip
  end

  def scaling_max(*args)
    args.unshift(1)
    args.select{ |i| i != nil && i != -1 }.max
  end
  def scaling_min(*args)
    args.unshift(1)
    args.select{ |i| i != nil && i != -1 }.min
  end

  def scale_range(from, to, max, max_choices)
    limit = to == -1 ? max : to
    return if limit > max_choices
    (from .. limit).map{ |i| [i.to_s, i] }
  end
  def scale_from_options(obj, max, max_choices=20)
    if range = scale_range(obj.supported_scales_from, obj.supported_scales_to, max, max_choices)
      {:as => :select, :collection => range, :include_blank => false}
    else
      {:as => :string}
    end
  end
  def scale_to_options(obj, max, max_choices=20)
    if range = scale_range(obj.supported_scales_from, obj.supported_scales_to, max, max_choices)
      range << [_('All available'), -1] if obj.supported_scales_to == -1
      {:as => :select, :collection => range, :include_blank => false}
    else
      {:as => :string, :hint => _('Use -1 to scale to your current account limits')}
    end
  end

  # @param [Integer] min
  # @param [Integer] max
  # @param [Hash] usage_rates (as returned by the User and Domain API objects)
  # @param [Boolean] scaling
  def storage_options(min, max, usage_rates={}, scaling=false)
    {:as => :select, :collection => (min..max), :include_blank => false}
  end

  def scale_options
    [[_('No scaling'),false],[_('Scale with web traffic'),true]]
  end

  def can_scale_application_type(type, capabilities=nil)
    type.scalable?
  end

  def cannot_scale_title(type, capabilities=nil)
    unless can_scale_application_type(type, capabilities)
      _("This application shares filesystem resources and can't be scaled.")
    end
  end

  def warn_may_not_scale(type, capabilities=nil)
    if type.may_not_scale?
      _("This application may require additional work to scale. Please see the application's documentation for more information.")
    end
  end

  def in_groups_by_tag(types, tags)
    categorized = []
    uncategorized = types

    tags.each do |tag|
      matches, uncategorized = uncategorized.partition {|type| type.tags.include?(tag)}
      if matches.length > 1
        categorized << [tag, matches]
      else
        uncategorized.concat matches
      end
    end

    [categorized, uncategorized]
  end

  def common_tags_for(ary)
    ary.length < 2 ? [] : ary.inject(nil){ |tags, a| tags ? (a.tags & tags) : a.tags } || []
  end

  def class_for_cartridge(cart)
    %w{jboss jbossews ruby php perl nodejs python mongodb mysql postgresql zend diy jenkins}.each do |c|
      return "icon-#{c}" if cart.name.match(c)
    end
    return "icon-cartridge"
  end
end
