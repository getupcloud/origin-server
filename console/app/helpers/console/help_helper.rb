module Console::HelpHelper
  include CommunityAware

  # Given a relative path within the user guide, display the topic
  def user_guide_topic_url(topic)
    # locale = 'en-US'
    # "http://access.redhat.com/knowledge/docs/#{locale}/OpenShift/2.0/html/User_Guide/#{topic}"
    
    # Use the community redirect to get to the user guide
    # No deep-linking of help topics is allowed
    user_guide_base_url topic
  end

  def user_guide_url
    user_guide_base_url
  end

  def newsletter_signup_url
    "http://getupcloud.us6.list-manage.com/subscribe?u=4a3f06f90d5382ab5ffde773d&id=53fc0caeda"
  end

  def ssh_keys_help_path
    getup_forum_article_url '23074108'
  end

  def deploy_hook_user_guide_topic_url
    user_guide_topic_url 'action-hooks'
  end

  def add_domains_user_guide_topic_url
    user_guide_topic_url 'add-a-custom-domain'
  end

  def product_architecture_url
    community_base_url 'products/architecture'
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

  def opensource_community_url
    community_base_url 'open-source'
  end

  def developers_url
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

  def downloadable_cartridges_help_url
    community_base_url 'developers/download-cartridges'
  end

  def post_to_forum_url
    community_base_url 'forums/openshift'
  end

  def jenkins_help_url
    community_base_url 'jenkins'
  end

  def knowledge_base_url
    community_base_url 'kb'
  end

  def faq_url
    getup_forum_article_url '/hc/pt-br/sections/201097135'
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

  def jboss_resources_url
    community_base_url 'developers/jboss'
  end

  def videos_url
    getup_youtube_url
  end

  def mongodb_resources_url
    community_base_url 'developers/mongodb'
  end

  def scaling_help_url
    community_base_url 'developers/scaling'
  end

  def getting_started_path(opts=nil)
     getup_forum_article_url "38835698"
  end

  def opensource_download_path(opts=nil)
    community_base_url "open-source/download-origin", opts
  end

  def cli_on_windows_user_guide_topic_url
    client_tools_install_help_url
  end

  def git_homepage_url
    "http://git-scm.com/"
  end

  def pricing_url
     getup_forum_article_url '/hc/pt-br/articles/205361075'
  end

  def create_quickstart_url
    user_guide_topic_url 'quickstarts'
  end

  def community_quickstarts_url
    'https://github.com/openshift-quickstart'
  end

  def alias_docs_url
    getup_forum_article_url '23608756'
  end

  def support_email
    'suporte@getupcloud.com'
  end

  def getupcloud_url
    getup_site_url
  end
end
