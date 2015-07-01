module Console
  module CommunityAware
    extend ActiveSupport::Concern

    included do
      helper_method :community_base_url, :community_path, :community_url if respond_to?(:helper_method)
      helper_method :getup_zendesk_url, :getup_forums_url, :getup_forum_article_url if respond_to?(:helper_method)
    end

    protected
      def community_path
        community_base_url('')
      end

      def community_url
        community_path
      end

      def community_base_url(path, opts=nil)
        "#{Console.config.community_url || "#{request.scheme}://#{request.host}/"}#{path}#{opts && opts[:anchor] ? "##{opts[:anchor]}" : ""}"
      end

      def getup_zendesk_url
        Console.config.env(:GETUP_ZENDESK_URL, 'https://getup.zendesk.com')
      end

      def getup_forums_url
        Console.config.env(:GETUP_FORUM_URL, getup_zendesk_url) + '/forums/'
      end

      def getup_forum_article_url(entry)
        Console.config.env(:GETUP_ZENDESK_URL, 'https://getup.zendesk.com') + '/entries/' + entry.to_s
      end

  end
end
