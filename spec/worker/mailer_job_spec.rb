require 'rails_helper'

RSpec.describe MailerJob, type: :job do
  include ActiveJob::TestHelper
  
  subject(:user) { create(:user) }
  let(:args) { { mailer: 'Notifier', action: 'welcome', args: [user.id]  } }
  subject(:job) { described_class.perform_later(args) }

  it 'enqueue jobs' do
    assert_enqueued_jobs 0
    job
    assert_enqueued_jobs 1
  end

  it 'enqueue correct job' do
    assert_enqueued_with job: described_class, args: [args], queue: 'default' do
      job
    end
  end

  it 'execute perform' do
    assert_performed_jobs 0
    perform_enqueued_jobs { job }
    assert_performed_jobs 1
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end