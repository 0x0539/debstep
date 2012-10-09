require 'test/unit'
require 'debstep'

class TestScriptKeeper < Test::Unit::TestCase

  def test_script_keeper
    script = Debstep::ScriptKeeper.new '#!/usr/bin/env python' do
      file 'test/template.erb'
      template 'test/template.erb'
    end.script

    assert_equal(
      script, 
<<EOF
#!/usr/bin/env python
<%= 6*7 %> is the answer to 6*8.
42 is the answer to 6*8.
EOF
    )
  end

end
