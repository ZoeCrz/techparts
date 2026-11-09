using System;
using System.Data;
using System.Text.RegularExpressions;
using MySql.Data.MySqlClient;

namespace wssTechParts2._0
{
    internal static class SqlProcedure
    {
        public static void Configure(MySqlCommand command, string procedure, params object[] values)
        {
            // Names are developer constants; only values are supplied by users.
            if (!Regex.IsMatch(procedure, @"\A[a-zA-Z_][a-zA-Z0-9_]*\z"))
                throw new ArgumentException("Invalid procedure name");
            command.Parameters.Clear();
            command.CommandType = CommandType.Text;
            string[] names = new string[values.Length];
            for (int i = 0; i < values.Length; i++)
            {
                names[i] = "@p" + i;
                command.Parameters.AddWithValue(names[i], values[i] ?? DBNull.Value);
            }
            command.CommandText = "CALL " + procedure + "(" + string.Join(",", names) + ");";
        }

        public static MySqlCommand Command(MySqlConnection connection, string name, params object[] values)
        {
            var command = new MySqlCommand();
            command.Connection = connection;
            Configure(command, name, values);
            return command;
        }

        public static MySqlDataAdapter Adapter(MySqlConnection connection, string name, params object[] values)
        {
            return new MySqlDataAdapter(Command(connection, name, values));
        }

        public static MySqlDataAdapter Adapter(string connectionString, string name, params object[] values)
        {
            var adapter = new MySqlDataAdapter();
            adapter.SelectCommand = new MySqlCommand();
            adapter.SelectCommand.Connection = new MySqlConnection(connectionString);
            Configure(adapter.SelectCommand, name, values);
            return adapter;
        }
    }
}
