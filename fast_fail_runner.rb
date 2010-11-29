# Usage:
#   ruby -rfast_fail_runner [test] --runner=fastfail
require 'test/unit'
require 'test/unit/ui/console/testrunner'

class FastFailRunner < Test::Unit::UI::Console::TestRunner
  def add_fault(fault)
    @faults << fault
    nl
    output("%3d) %s" % [@faults.length, fault.long_display])
    output("--")
    @already_outputted = true
  end

  def finished(elapsed_time)
    nl
    output("Finished in #{elapsed_time} seconds.")
    nl
    output(@result)
  end
end

Test::Unit::AutoRunner::RUNNERS[:fastfail] = proc do |r|
  FastFailRunner
end
