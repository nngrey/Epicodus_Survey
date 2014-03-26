require 'spec_helper'

describe Response do
  it { should belong_to :answer }
  it { should belong_to :respondent }
end
