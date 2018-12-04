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
      connection = double
      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_yield(connection)
      allow(connection).to receive(:transaction).and_yield
      allow(connection).to receive(:execute).with(/CREATE TEMP(ORARY)? TABLE/i)
      allow(connection).to receive(:drop_table).with(described_class::DEFAULT_TABLE_NAME, if_exists: true)
      begin
        described_class.with_temptable(User.all, []) { raise StandardError.new('Raised error') }
      rescue
      end
      expect(connection).to have_received(:transaction)
      expect(connection).to have_received(:execute).exactly(:once)
      expect(connection).to have_received(:drop_table).exactly(:once)
    end

    it 'creates indexes' do
      args = [:id, [:email, unique: true], [[:id, :email], unique: true]]
      tablename = 'test_temp_table'

      connection = double
      allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_yield(connection)
      allow(connection).to receive(:transaction).and_yield
      allow(connection).to receive(:execute).with(an_instance_of(String)).at_least(:once)
      allow(connection).to receive(:drop_table).with(tablename, if_exists: true)
      allow(connection).to receive(:add_index).with(tablename, args[0], {})
      allow(connection).to receive(:add_index).with(tablename, args[1][0], args[1][1])
      allow(connection).to receive(:add_index).with(tablename, args[2][0], args[2][1])
      described_class.with_temptable(User.all, args, tablename) {}
      expect(connection).to have_received(:add_index).exactly(3).times
      expect(connection).to have_received(:drop_table).exactly(:once)
    end
  end
end
