﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Entities;

namespace DAL.Department
{
    public class SQLRequestesDAO
    {
        private readonly SqlConnection DBConnection;
        public SQLRequestesDAO()
        {
            DBConnection = DBAccess.GetDBConnection();
        }

        public IEnumerable<Film> GetAllFilms()
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand("GetAllFilms", DBConnection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetByte(0);
                    string name = dataReader.GetString(dataReader.GetOrdinal("FilmName"));
                    DateTime year = dataReader.GetDateTime(dataReader.GetOrdinal("ReleaseYear"));
                    string director = dataReader.GetString(dataReader.GetOrdinal("Director"));
                    int duration = dataReader.GetInt16(dataReader.GetOrdinal("Duration"));
                    string genre = dataReader.GetString(dataReader.GetOrdinal("Genre"));
                    float rating = (float)dataReader.GetDouble(dataReader.GetOrdinal("Rating"));
                    string image = dataReader.GetString(dataReader.GetOrdinal("FilmImage"));

                    yield return new Film(id, name, year, director, duration, genre, rating, image); ;
                }
            } finally
            {
                DBConnection.Close();
            }
        }
        public IEnumerable<Ticket> GetTicketsForSeance(int seance)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand("GetTicketsForSeance", DBConnection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@seance", seance);

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetInt16(dataReader.GetOrdinal("TicketID"));
                    string type = dataReader.GetString(dataReader.GetOrdinal("TicketType"));
                    int cashId = dataReader.GetByte(dataReader.GetOrdinal("CashboxID"));
                    int seanceId = dataReader.GetByte(dataReader.GetOrdinal("SeanceId"));
                    int row = dataReader.GetByte(dataReader.GetOrdinal("RowNumber"));
                    int seat = dataReader.GetByte(dataReader.GetOrdinal("SeatNumber"));
                    int cost = dataReader.GetInt16(dataReader.GetOrdinal("Cost"));

                    yield return new Ticket(id, type, cashId, seanceId, row, seat, cost);
                }
            }
            finally
            {
                DBConnection.Close();
            }
        }
        public Seance GetSeanceInfo(int seance)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand(@"GetSeanceInfo", DBConnection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@seance", seance);

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetByte(dataReader.GetOrdinal("SeanceId"));
                    int fimlId = dataReader.GetByte(dataReader.GetOrdinal("FilmID"));
                    int hollId = dataReader.GetByte(dataReader.GetOrdinal("HollID"));
                    DateTime time = dataReader.GetDateTime(dataReader.GetOrdinal("ShowTime"));
                    int rating = dataReader.GetByte(dataReader.GetOrdinal("AgeRating"));
                    string type = dataReader.GetString(dataReader.GetOrdinal("SeanceType"));
                    int cost = dataReader.GetByte(dataReader.GetOrdinal("TicketCost"));

                    return new Seance(id, fimlId, hollId, time, rating, type, cost);
                }
            }
            finally { 
            
                DBConnection.Close();
            }
            return null;
        }
        public Film GetFilmById(int film)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand(@"GetFilmById", DBConnection);
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@film", film);

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetByte(0);
                    string name = dataReader.GetString(dataReader.GetOrdinal("FilmName"));
                    DateTime year = dataReader.GetDateTime(dataReader.GetOrdinal("ReleaseYear"));
                    string director = dataReader.GetString(dataReader.GetOrdinal("Director"));
                    int duration = dataReader.GetInt16(dataReader.GetOrdinal("Duration"));
                    string genre = dataReader.GetString(dataReader.GetOrdinal("Genre"));
                    float rating = (float)dataReader.GetDouble(dataReader.GetOrdinal("Rating"));
                    string image = dataReader.GetString(dataReader.GetOrdinal("FilmImage"));

                    return new Film(id, name, year, director, duration, genre, rating, image);
                }
            }
            finally
            {

                DBConnection.Close();
            }
            return null;
        }
        public IEnumerable<Seance> GetSeancesForFilms(int film)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand(@"SELECT* FROM Seances WHERE FilmID = @FilmID", DBConnection);
                command.Parameters.AddWithValue("@FilmID", film);

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetByte(dataReader.GetOrdinal("SeanceId"));
                    int fimlId = dataReader.GetByte(dataReader.GetOrdinal("FilmID"));
                    int hollId = dataReader.GetByte(dataReader.GetOrdinal("HollID"));
                    DateTime time = dataReader.GetDateTime(dataReader.GetOrdinal("ShowTime"));
                    int rating = dataReader.GetByte(dataReader.GetOrdinal("AgeRating"));
                    string type = dataReader.GetString(dataReader.GetOrdinal("SeanceType"));
                    int cost = dataReader.GetByte(dataReader.GetOrdinal("TicketCost"));

                    yield return new Seance(id, fimlId, hollId, time, rating, type, cost);
                }
            }
            finally
            {
                DBConnection.Close();
            }
        }
        public CinemaHoll GetCinemaHollInfoBySeance(int seance)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                SqlCommand command = new SqlCommand(@"GetHollInfoBySeance", DBConnection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@seance", seance);

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    int id = dataReader.GetByte(dataReader.GetOrdinal("HollID"));
                    bool td = dataReader.GetBoolean(dataReader.GetOrdinal("TdEnable"));
                    int rows = dataReader.GetByte(dataReader.GetOrdinal("RowNumber"));
                    int seats = dataReader.GetByte(dataReader.GetOrdinal("SeatNumber"));

                    return new CinemaHoll(id, td, rows, seats);
                }
            }
            finally
            {

                DBConnection.Close();
            }
            return null;
        }

        public void CreateTickets(List<Ticket> tickets)
        {
            if (DBConnection.State != System.Data.ConnectionState.Open)
                DBConnection.Open();
            try
            {
                foreach (var ticket in tickets)
                {
                    SqlCommand command = new SqlCommand(@"CreateTicket", DBConnection)
                    {
                        CommandType = System.Data.CommandType.StoredProcedure
                    };
                    command.Parameters.AddWithValue("@SeanceId", ticket.SeanceId);
                    command.Parameters.AddWithValue("@TypeName", ticket.TicketType);
                    command.Parameters.AddWithValue("@CashboxID", ticket.CashboxID);
                    command.Parameters.AddWithValue("@RowNumber", ticket.RowNumber);
                    command.Parameters.AddWithValue("@SeatNumber", ticket.SeatNumber);
                    command.Parameters.AddWithValue("@Cost", ticket.Cost);

                    if (command.ExecuteNonQuery() < 1) 
                    {
                        throw new Exception("Error with ticket");
                    }
                }
            }
            finally
            {
                DBConnection.Close();
            }
        }
    }
}
