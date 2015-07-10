module Console::HelpHelper
  include CommunityAware

  def getup_community_path
    getup_forums_url
  end

  # Given a relative path within the user guide, display the topic
  def user_guide_topic_url(topic)
    # locale = 'en-US'
    # "http://access.redhat.com/knowledge/docs/#{locale}/OpenShift/2.0/html/User_Guide/#{topic}"
    
    # Use the community redirect to get to the user guide
    # No deep-linking of help topics is allowed
    community_base_url 'user-guide'
  end

  def user_guide_url
    user_guide_topic_url 'index.html'
  end

  def newsletter_signup_url
    "http://getupcloud.us6.list-manage.com/subscribe?u=4a3f06f90d5382ab5ffde773d&id=53fc0caeda"
  end

  def ssh_keys_help_path
    community_base_url 'developers/remote-access#keys'
  end

  def deploy_hook_user_guide_topic_url
    community_base_url 'developers/deploying-and-building-applications'
  end

  def add_domains_user_guide_topic_url
    user_guide_topic_url 'chap-OpenShift-User_Guide-Namespaces.html'
  end

  def product_architecture_url
    community_base_url 'products/architecture'
  end

  def products_url
    community_base_url 'products'
  end

  def cartridge_list_url
    community_base_url 'developers/technologies'
  end

  def get_involved_url
    community_base_url 'get-involved'
  end

  def suggest_features_url
    getup_forum_article_url '21724148'
  end

  def openshift_blog_url
    getup_blog_url
  end

  def openshift_twitter_url
    "http://twitter.com/openshift"
  end

  def openshift_facebook_url
    "http://facebook.com/openshift"
  end

  def openshift_google_plus_url
    "https://plus.google.com/b/108052331678796731786/108052331678796731786/posts"
  end

  def opensource_community_url
    community_base_url 'open-source'
  end

  def get_involved_developers_url
    community_base_url 'developers/get-involved'
  end

  def partners_url
    community_base_url 'partners'
  end

  def get_started_quickstart_url
    getup_forum_article_url '38835698'
  end

  def developers_url
    community_base_url 'developers'
  end

  def developers_path
    community_base_url 'developers'
  end

  def support_path
    getup_forums_url
  end

  def ssh_help_url
    getup_forum_article_url '23074108'
  end

  def client_tools_install_help_url
    getup_forum_article_url '23056511'
  end

  def client_tools_help_url
    community_base_url 'developers/tools'
  end

  def developers_get_help_url
    community_base_url 'developers/get-help'
  end

  def developers_get_started_path
    community_base_url 'developers/get-started'
  end

  def downloadable_cartridges_help_url
    community_base_url 'developers/download-cartridges'
  end

  def livecd_wiki_url(anchor=nil)
    community_base_url "wiki/getting-started-with-openshift-origin-livecd#{anchor.present? ? "##{anchor}" : ''}"
  end

  def post_to_forum_url
    community_base_url 'forums/openshift'
  end

  def events_url
    community_base_url 'events'
  end

  def jenkins_help_url
    community_base_url 'jenkins'
  end

  def forums_url
    community_base_url 'forums/openshift'
  end

  def knowledge_base_url
    community_base_url 'kb'
  end

  def faq_url
   community_base_url 'faq'
  end

  def signup_faq_url
    community_base_url 'faq/i-just-signed-up-why-didnt-i-receive-an-email-confirmation'
  end

  def developers_get_started_fast_url
    community_base_url 'developers/get-started'
  end

  def community_search_url
    community_base_url 'search/gcse'
  end

  def sync_git_with_remote_repo_knowledge_base_url
    community_base_url 'kb/kb-e1006-sync-new-express-git-repo-with-your-own-existing-git-repo'
  end

  def rails_quickstart_guide_url
    community_base_url 'kb/kb-e1005-ruby-on-rails-express-quickstart-guide'
  end

  def jboss_resources_url
    community_base_url 'developers/jboss'
  end

  def videos_url
    getup_youtube_url
  end

  def blog_post_url(post)
    community_base_url "blogs/#{post}"
  end

  def community_document_url(file)
    community_base_url "sites/default/files/documents/#{file}"
  end

  def mongodb_resources_url
    community_base_url 'developers/mongodb'
  end

  def scaling_help_url
    community_base_url 'developers/scaling'
  end

  def storage_help_url
    community_base_url 'hc/pt-br/articles/205361075'
  end

  def user_guide_url
    user_guide_topic_url 'index.html'
  end

  def getting_started_path(opts=nil)
    community_base_url "entries/38835698"
  end

  def product_overview_path(opts=nil)
    community_base_url "products", opts
  end

  def opensource_process_url
    community_base_url "wiki/community-process"
  end

  def opensource_architecture_url
    community_base_url "wiki/architecture-overview"
  end

  def opensource_download_path(opts=nil)
    community_base_url "open-source/download-origin", opts
  end
  def opensource_download_url(opts=nil)
    opensource_download_path opts
  end

  def getting_started_guide_url
    community_base_url 'developers/install-the-client-tools'
  end

  def cli_on_windows_user_guide_topic_url
    community_base_url 'developers/install-the-client-tools#windows'
  end

  def git_homepage_url
    "http://git-scm.com/"
  end

  def pricing_url(opts = nil)
    community_base_url 'hc/pt-br/articles/205361075'
  end

  def legal_url
    community_base_url 'legal'
  end

  def policy_url
    community_base_url 'policy'
  end

  def services_agreement_url
    community_base_url 'legal/services_agreement'
  end

  def acceptable_use_url
    community_base_url 'legal/acceptable_use'
  end

  def privacy_policy_url
    community_base_url 'legal/openshift_privacy'
  end

  def terms_of_service_url
    community_base_url 'legal/site_terms'
  end

  def security_policy_url
    community_base_url 'policy/security'
  end

  def create_quickstart_url
    community_base_url 'node/add/quickstart'
  end

  def community_quickstarts_url
    community_base_url 'quickstarts'
  end

  def console_help_links
    [
      {:href => developers_url,
       :name => _('Developer Center')},
      {:href => user_guide_url,
       :name => _('OpenShift User Guide')},
      {:href => getting_started_path,
       :name => _('Installing OpenShift client tools on Mac OSX, Linux, and Windows')},
      {:href => sync_git_with_remote_repo_knowledge_base_url,
       :name => _('Sync your OpenShift repo with an existing Git repo')}
    ]
  end

  def console_faq_links
    [
      {:href => getup_forum_article_url('23608756'),
       :name => _("How to use my own domain?")},
      {:href => cli_on_windows_user_guide_topic_url,
       :name => _("How to install rhc client tool for Windows?")},
      {:href => getup_forum_article_url('23042806'),
       :name => _("How to publish my site files? which tools shoud I use?")}
    ]
  end

  def enterprise_evaluation_request_url
    community_base_url 'page/openshift-enterprise-online-evaluation-request'
  end

  def resource_request_url
    community_base_url 'page/resource-request-form'
  end

  def alias_docs_url
    getup_forum_article_url '23608756'
  end

  def support_email
    'support@getupcloud.com'
  end

  def support_url
    getup_forums_url
  end

  def getupcloud_url
    getup_site_url
  end
end
