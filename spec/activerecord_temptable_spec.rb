# frozen_string_literal: true
require 'fixtures/models'
require 'support/shared_examples/simple_query'

RSpec.describe ActiveRecordTemptable do
  CONFIG.each do |database, config|
    context database do
      include_examples 'queries', config
    end
  end

  describe 'creating table' do
    before(:all) do
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
      load File.join(__dir__, 'fixtures', 'schema.rb')
    end

    it 'creates and drops temp table' do
      allow(ActiveRecord::Base.connection).to receive(:execute).with(/CREATE TEMP(ORARY)? TABLE/i)
      allow(ActiveRecord::Base.connection).to receive(:execute).with(/DROP TABLE IF EXISTS/i)
      begin
        described_class.with_temptable(User.all, []) { raise StandardError.new('Raised error') }
      rescue
      end
      expect(ActiveRecord::Base.connection).to have_received(:execute).exactly(2).times
    end

    it 'creates indexes' do
      args = [:id, [:email, unique: true], [[:id, :email], unique: true]]
      tablename = 'test_temp_table'

      allow(ActiveRecord::Base.connection).to receive(:add_index).with(tablename, args[0], {})
      allow(ActiveRecord::Base.connection).to receive(:add_index).with(tablename, args[1][0], args[1][1])
      allow(ActiveRecord::Base.connection).to receive(:add_index).with(tablename, args[2][0], args[2][1])
      described_class.with_temptable(User.all, args, tablename) {}
      expect(ActiveRecord::Base.connection).to have_received(:add_index).exactly(3).times
    end
  end
end
