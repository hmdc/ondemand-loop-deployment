# frozen_string_literal: true
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test 'restart_url builds nginx stop path with root redir' do
    assert_equal '/nginx/stop?redir=/', restart_url
  end

  test 'files_app_url joins configuration path' do
    Configuration.stubs(:files_app_path).returns('/data')
    assert_equal '/data/sub', files_app_url('sub')
  end

  test 'ood_dashboard_url reads config' do
    Configuration.stubs(:ood_dashboard_path).returns('/dash')
    assert_equal '/dash', ood_dashboard_url
  end

  test 'nav_link_to adds active when current page' do
    self.stubs(:current_page?).with('/home').returns(true)
    html = nav_link_to('Home', '/home', class: 'nav')
    assert_includes html, 'class="nav active"'
    assert_includes html, 'aria-current="page"'
  end

  test 'alert_class maps types to bootstrap alerts' do
    assert_equal 'alert alert-danger', alert_class(:error)
    assert_equal 'alert alert-info', alert_class(:other)
  end

  test 'status_badge renders span with status text' do
    html = status_badge(FileStatus::SUCCESS, title: 'ok', filename: 'f')
    assert_includes html, 'badge file-status bg-success'
    assert_includes html, 'role="status"'
  end
end
