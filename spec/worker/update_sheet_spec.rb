require 'rails_helper'

RSpec.describe UpdateSheetJob, type: :job do
  include ActiveJob::TestHelper
  
  before do
    user = create(:user)
    5.times { create(:product, category: 'snack') }
    5.times { create(:product, category: 'drink') }
    5.times { create(:transaction, :purchase, account: user.account) }
  end

  subject(:sync_job) { described_class.perform_later(:google, true) }

  it 'enqueue jobs' do
    assert_enqueued_jobs 0
    sync_job
    assert_enqueued_jobs 1
  end

  it 'execute perform' do
    assert_performed_jobs 0
    perform_enqueued_jobs { sync_job }
    assert_performed_jobs 1
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end