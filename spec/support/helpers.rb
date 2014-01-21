module SpecHelpers
  def setup_site
    site = create('test site')

    writers = build(:content_type, site: site, name: "Writers", _user: true)
    writers.entries_custom_fields.build(label: "Email", type: "email")
    writers.entries_custom_fields.build(label: "First Name", type: "string", required: false)
    writers.save!

    editors = build(:content_type, site: site, name: "Editors", _user: true)
    editors.entries_custom_fields.build(label: "Email", type: "email")
    editors.entries_custom_fields.build(label: "First Name", type: "string", required: false)
    editors.save!

    # @ctype = build(:content_type, site: site, name: "Examples")
    # @ctype.entries_custom_fields.build(label: "Name", type: "string", searchable: true)
    # @ctype.save!
    # @stuff_field = @ctype.entries_custom_fields.build(label: "Stuff", type: "text", searchable: false)
    # @stuff_field.save!
    # @ctype.entries.create!(name: "Findable entry", stuff: "Some stuff")
    # @ctype.entries.create!(name: "Hidden", stuff: "Not findable")

    create(:sub_page, site: site, title: "Please search for this findable page", slug: "findable", raw_template: "This is what you were looking for")
    create(:sub_page, site: site, title: "Unpublished findable", slug: "unpublished-findable", raw_template: "Not published, so can't be found", published: false)
    create(:sub_page, site: site, title: "Seems findable", slug: "seems-findable", raw_template: "Even if it seems findable, it sound't be found because of the searchable flag")

    # create(:sub_page, site: site, title: "search", slug: "search", raw_template: <<-EOT
    #   * Search results:
    #   <ul>
    #     {% for result in site.search %}
    #       {% if result.content_type_slug == 'examples' %}
    #         <li><a href="/examples/{{result._slug}}">{{ result.name }}</a></li>
    #       {% else %}
    #         <li><a href="/{{result.fullpath}}">{{ result.title }}</a></li>
    #       {% endif %}
    #     {% endfor %}
    #   </ul>
    # EOT
    # )

    another_site = create('another site')

    create(:sub_page,
      site: another_site,
      title: 'Writers',
      slug: 'writers',
      raw_template: 'CMS Writers Page'
    )

    [site, another_site].each do |s|
      create(:sub_page,
        site: s,
        title: 'User Status',
        slug: 'status',
        raw_template: <<-EOT
          User Status:
          {% if end_user.logged_in? %}
          Logged in as {{ end_user.type }} with email {{ end_user.email }}
          {% else %}
          Not logged in.
          {% endif %}
        EOT
      )

      home = s.pages.where(slug: 'index').first
      home.raw_template = <<-EOF
        Notice: {{ flash.notice }}
        Error: {{ flash.error }}
        Content of the home page.
      EOF
      home.save!
    end

    another_editors = build(:content_type, site: another_site, name: "Editors", _user: true)
    another_editors.entries_custom_fields.build(label: "Email", type: "email")
    another_editors.entries_custom_fields.build(label: "First Name", type: "string", required: false)
    another_editors.save!
  end
end

RSpec.configure { |c| c.include SpecHelpers }
