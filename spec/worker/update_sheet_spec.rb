require 'rails_helper'

RSpec.describe UpdateSheetJob, type: :job do
  include ActiveJob::TestHelper
  
  let(:adapter) { :google }
  subject(:job) { described_class.perform_later(adapter) }

  it 'enqueue jobs' do
    assert_enqueued_jobs 0
    job
    assert_enqueued_jobs 1
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end