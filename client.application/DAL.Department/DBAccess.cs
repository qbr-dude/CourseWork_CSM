using System;
using System.Data.SqlClient;
using System.Configuration;

namespace DAL.Department
{
    class DBAccess
    {
        public static SqlConnection SetDBConnection(string configString)
        {
            string connectionString = configString;
            return new SqlConnection(connectionString);
        }

        public static SqlConnection GetDBConnection()
        {
            string configurationString = ConfigurationManager.ConnectionStrings["CinemaDB"].ConnectionString;
            SqlConnection sqlConnection = SetDBConnection(configurationString);
            sqlConnection.StateChange += SqlConnection_StateChange;
            return SetDBConnection(configurationString);
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
