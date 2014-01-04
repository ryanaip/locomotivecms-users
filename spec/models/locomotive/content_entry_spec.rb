require 'spec_helper'

describe Locomotive::ContentEntry do
  let(:content_type) { FactoryGirl.build(:content_type) }

  before(:each) do
    content_type._user = true

    content_type.entries_custom_fields.build label: 'Title', type: 'string'
    content_type.entries_custom_fields.build label: 'Description', type: 'text'
    content_type.entries_custom_fields.build label: 'Visible ?', type: 'boolean', name: 'visible'
    content_type.entries_custom_fields.build label: 'File', type: 'file'

    content_type.valid?
    content_type.send(:set_label_field)
  end

  def build_content_entry(options = {})
    content_type.entries.build({
      title: 'Locomotive',
      description: 'Lorem ipsum....',
      _label_field_name: 'title',
      created_at: Time.zone.parse('2013-07-05 00:00:00')
    }.merge(options))
  end

end
