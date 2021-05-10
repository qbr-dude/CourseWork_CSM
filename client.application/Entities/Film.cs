using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
    public class Film
    {
        public int FilmID { private set; get; }
        public string FilmName { private set; get; }
        public DateTime ReleaseYear { private set; get; }
        public string Director { private set; get; }
        public int Duration { private set; get; }
        public string Genre { private set; get; }
        public float Rating { private set; get; }
        public string FilmImage { private set; get; }

        public Film(int id, string name, DateTime year, string director, int duration, string genre, float rating, string image)
        {
            FilmID = id;
            FilmName = name;
            ReleaseYear = year;
            Director = director;
            Duration = duration;
            Genre = genre;
            Rating = rating;
            FilmImage = image;
        }

    }
}
