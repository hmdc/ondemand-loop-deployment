require 'test_helper'

class Dataverse::Actions::UploadBundleCreateTest < ActiveSupport::TestCase
  include ModelHelper

  def setup
    @project = create_project
    @action = Dataverse::Actions::UploadBundleCreate.new
  end

  test 'create handles Dataverse url' do
    Dataverse::CollectionService.stubs(:new).returns(stub(find_collection_by_id: OpenStruct.new(data: OpenStruct.new(name: 'root'))))
    result = @action.create(@project, object_url: 'http://dv.org')
    assert result.success?
  end

  test 'create handles collection url' do
    service = mock('service')
    collection = mock('collection')
    collection.stubs(:data).returns(OpenStruct.new({name: 'Collection Title', alias: 'collection_id', parents: []}))
    service.expects(:find_collection_by_id).with('collection_id').returns(collection)
    Dataverse::CollectionService.stubs(:new).returns(service)

    Common::FileUtils.any_instance.stubs(:normalize_name).returns('bundle')
    UploadBundle.any_instance.stubs(:save)
    result = @action.create(@project, object_url: 'http://dv.org/dataverse/collection_id')
    assert result.success?
    assert_equal 'Collection Title', result.resource.metadata[:collection_title]
  end

  test 'create handles dataset url' do
    service = mock('service')
    ds = mock('ds')
    ds.stubs(:data).returns(OpenStruct.new(parents: [{name: 'root'}, {name: 'col', identifier: 'c1'}]))
    ds.stubs(:metadata_field).with('title').returns('Dataset Title')
    service.expects(:find_dataset_version_by_persistent_id).with('DS1').returns(ds)
    Dataverse::DatasetService.stubs(:new).returns(service)

    Common::FileUtils.any_instance.stubs(:normalize_name).returns('bundle')
    UploadBundle.any_instance.stubs(:save)
    result = @action.create(@project, object_url: 'http://dv.org/dataset.xhtml?persistentId=DS1')
    assert result.success?
    assert_equal 'Dataset Title', result.resource.metadata[:dataset_title]
  end
end
