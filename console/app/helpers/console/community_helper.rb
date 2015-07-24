module Console::CommunityHelper

  def irc_web_url
    Console.config.env(:IRC_WEB_URL, 'http://webchat.freenode.net/?randomnick=1&channels=openshift&uio=d4')
  end

  def openshift_twitter_url
    Console.config.env(:OPENSHIFT_TWITTER_URL, 'http://twitter.com/openshift')
  end

  def openshift_ops_twitter_url
    Console.config.env(:OPENSHIFT_OPS_TWITTER_URL, 'http://twitter.com/openshift_ops')
  end

  def open_bug_url
    Console.config.env(:OPEN_BUG_URL, 'https://bugzilla.redhat.com/enter_bug.cgi?product=OpenShift%20Origin')
  end

  def openshift_github_url
    Console.config.env(:OPENSHIFT_GITHUB_URL, 'https://github.com/openshift')
  end

  def openshift_github_project_url(project)
    "#{openshift_github_url}/#{project}"
  end

  def contact_mail
    Console.config.env(:CONTACT_MAIL, 'suporte@getupcloud.com')
  end 

  def mailto_openshift_url
    'mailto:'+contact_mail
  end

  def status_jsonp_url(id)
    status_js_path :id => id
  end

  def open_issues_jsonp_url(jsonp)
    open_issues_js_path :jsonp => jsonp
  end

  def getup_credit_url
    getup_forum_article_url '61852715'
  end

  def getup_youtube_url
    'https://www.youtube.com/user/getupcloud'
  end

  def getup_site_url
    Console.config.env(:GETUP_SITE_URL, 'https://getupcloud.com/')
  end

  def getup_blog_url
    Console.config.env(:GETUP_BLOG_URL, 'https://getupcloud.com/blog/')
  end
end
