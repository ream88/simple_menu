require File.expand_path('../spec_helper', __FILE__)

describe SimpleMenu do
  let(:template) do
    Class.new do
      def link_to(name, path, options = {})
        tag(:a, name, options.merge(href: path))
      end

      def tag(tag, content = '', options = {})
        html = ''
        html << "<#{tag}"
        html << options.map { |k, v| " #{k}=\"#{v}\"" }.join
        html << ">#{content}</#{tag}}"
      end

      def url_for
        '/'
      end

      def root_url
        '/'
      end
    end.new
  end
  subject { SimpleMenu.new(template) }

  it 'creates menu using the simpelst syntax available' do
    SimpleMenu.new(template) do
      link_to('Link', 'link')
    end.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="link">Link</a>
        </li>
      </ul>
    HTML
  end

  it 'creates valid HTML even if empty' do
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul></ul>
    HTML
  end

  it 'create simple menus' do
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { link_to('Link 2', '/link/2') }
    
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="/link/1">Link 1</a>
        </li>
        <li>
          <a href="/link/2">Link 2</a>
        </li>
      </ul>
    HTML
  end

  it 'also creates complex menus' do
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { tag(:strong, 'Not a Link') }
    subject.add { link_to('Link 2', '/link/2') }
    subject.add { link_to('Impossible Link', '/link/impossible') } if true == false
    
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="/link/1">Link 1</a>
        </li>
        <li>
          <strong>Not a Link</strong>
        </li>
        <li>
          <a href="/link/2">Link 2</a>
        </li>
      </ul>
    HTML
  end

  it 'allows adding links before other links' do
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { link_to('Link 4', '/link/4') }
    
    subject.before('Link 4') { link_to('Link 3', '/link/3') }
    subject.before('Link 3') { link_to('Link 2', '/link/2') }
    
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="/link/1">Link 1</a>
        </li>
        <li>
          <a href="/link/2">Link 2</a>
        </li>
        <li>
          <a href="/link/3">Link 3</a>
        </li>
        <li>
          <a href="/link/4">Link 4</a>
        </li>
      </ul>
    HTML
  end

  it 'allows adding links after other links' do
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { link_to('Link 4', '/link/4') }
    
    subject.after('Link 1') { link_to('Link 2', '/link/2') }
    subject.after('Link 2') { link_to('Link 3', '/link/3') }
    
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="/link/1">Link 1</a>
        </li>
        <li>
          <a href="/link/2">Link 2</a>
        </li>
        <li>
          <a href="/link/3">Link 3</a>
        </li>
        <li>
          <a href="/link/4">Link 4</a>
        </li>
      </ul>
    HTML
  end

  it 'highlights current path' do
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { link_to('Current Link', '/') }
    
    subject.to_s.must_equal(<<-HTML.unindent)
      <ul>
        <li>
          <a href="/link/1">Link 1</a>
        </li>
        <li>
          <a href="/" class="active">Current Link</a>
        </li>
      </ul>
    HTML
  end

  it 'forwards unknown methods to template' do
    mock = MiniTest::Mock.new
    subject = SimpleMenu.new(mock)
    
    mock.expect(:send, '<a href="/link/1">Link 1</a>', [:link_to, 'Link 1', '/link/1'])
    mock.expect(:send, '<a href="/link/2">Link 2</a>', [:link_to, 'Link 2', '/link/2'])
    mock.expect(:send, '<a href="mailto:mail@example.org">Mail</a>', [:mail_to, 'Mail', 'mail@example.org'])
    mock.expect(:send, '<strong>Not a Link</strong>', [:content_tag, :strong, 'Not a Link'])
    
    subject.add { link_to('Link 1', '/link/1') }
    subject.add { link_to('Link 2', '/link/2') }
    subject.add { mail_to('Mail', 'mail@example.org') }
    subject.add { content_tag(:strong, 'Not a Link') }
    
    mock.verify
  end
end