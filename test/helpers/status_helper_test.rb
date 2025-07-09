# frozen_string_literal: true
require 'test_helper'

class StatusHelperTest < ActionView::TestCase
  include StatusHelper

  test 'cancel_button_disabled? should be true for these statuses' do
    [FileStatus::SUCCESS, FileStatus::ERROR, FileStatus::CANCELLED].each do |status|
      assert cancel_button_disabled?(status)
    end
  end

  test 'cancel_button_disabled should be false for these statuses' do
    [FileStatus::PENDING, FileStatus::DOWNLOADING, FileStatus::UPLOADING].each do |status|
      refute cancel_button_disabled?(status)
    end
  end
end
