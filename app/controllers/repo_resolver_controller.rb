class RepoResolverController < ApplicationController
  include LoggingCommon

  def resolve
    repo_url = params[:repo_url]
    if repo_url.blank?
      redirect_back fallback_location: root_path, alert: t('.blank_url_error')
      return
    end

    repo_resolver = Repo::RepoResolverService.new(RepoRegistry.resolvers)
    url_resolution = repo_resolver.resolve(repo_url)
    if url_resolution.unknown?
      redirect_back fallback_location: root_path, alert: t('.url_not_supported', url: repo_url)
      return
    end

    controller_resolver = ConnectorClassDispatcher.repo_controller_resolver(url_resolution.type)
    result = controller_resolver.get_controller_url(url_resolution.object_url)

    flash_message = result.message || {}
    redirect_to result.redirect_url, **flash_message
  end

end
