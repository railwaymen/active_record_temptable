# frozen_string_literal: true

require "active_record_temptable/version"
require 'active_record'

module ActiveRecordTemptable
  extend self

  def with_temptable(relation, indexes = [], table_name='activerecord_temptable_records')
    ActiveRecord::Base.connection.transaction do
    begin
      ActiveRecord::Base.connection.execute(new_table_command(relation, table_name))
      create_indexes(table_name, indexes) if indexes.any?
      klass = relation.klass
      yield klass.unscoped.from("#{table_name} AS #{klass.table_name}")
    ensure
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{table_name}")
    end
    end
  end

  private

  def new_table_command(relation, table_name)
    <<-SQL
    CREATE TEMPORARY TABLE #{table_name} AS #{relation.to_sql}
    SQL
  end

  def create_indexes(table_name, indexes)
    puts table_name.inspect
    puts indexes.inspect
    indexes.each do |fields, options|
      puts [fields, options].inspect
      ActiveRecord::Base.connection.add_index(table_name, fields, options || {})
    end
  end
end
