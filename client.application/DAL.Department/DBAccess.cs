using System;
using System.Data.SqlClient;

namespace DAL.Department
{
    class DBAccess
    {
        public static SqlConnection SetDBConnection(string datasourse, string database, string user)
        {
            string connectionString = @"Data Source = " + datasourse + ";Initial Catalog = " + database + ";Integrated Security=SSPI;";
            return new SqlConnection(connectionString);
        }

        public static SqlConnection GetDBConnection()
        {
            string datasourse = @"QBR_DUDE\SQLEXPRESS";
            string database = "CinemaDB";
            string user = @"QBR_DUDE\Dmitriy";

            SqlConnection sqlConnection = SetDBConnection(datasourse, database, user);
            sqlConnection.StateChange += SqlConnection_StateChange;
            return SetDBConnection(datasourse, database, user);
        }

        private static void SqlConnection_StateChange(object sender, System.Data.StateChangeEventArgs e)
        {
            if (e.CurrentState == System.Data.ConnectionState.Broken)
            {
                (sender as SqlConnection).Dispose();
                GetDBConnection();
            }
        }
    }
}
