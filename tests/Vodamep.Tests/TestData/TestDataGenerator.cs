﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Vodamep.Hkpv.Model;
using Vodamep.Hkpv.Validation;
using Vodamep.Model;

namespace Vodamep.TestData
{
    public class TestDataGenerator
    {
        private static long _id = 1;
        private Random _rand = new Random();
        private string[] _addresses;
        private string[] _names;
        private string[] _familynames;
        private string[] _activities;

        public TestDataGenerator()
        {
            _addresses = File.ReadAllLines("TestData/gemplzstr_8.csv", Encoding.UTF8);
            _names = File.ReadAllLines("TestData/Vornamen.txt", Encoding.UTF8);
            _familynames = File.ReadAllLines("TestData/Nachnamen.txt", Encoding.UTF8);
            _activities = File.ReadAllLines("TestData/Aktivitäten.txt", Encoding.UTF8);
        }

        public (Person Person, PersonalData data) CreatePerson()
        {
            var id = (_id++).ToString();

            var person = new Person()
            {
                Id = id,
                Insurance = "19",
                Religion = "r.k."
            };

            var data = new PersonalData
            {
                Id = id,
                FamilyName = _familynames[_rand.Next(_familynames.Length)],
                GivenName = _names[_rand.Next(_names.Length)]
            };

            // die Anschrift
            {
                var line = 3 + _rand.Next(_addresses.Length - 5);  // die ersten drei und die letzte Zeile sind ungültig
                var address = _addresses[line].Split(';');

                data.Country = "Österreich";
                data.Postcode = address[6];
                data.City = address[3];
                data.Street = string.Format("{0} {1}", address[5], 1 + _rand.Next(30));
            }

            data.Birthday = new Model.LocalDate(new DateTime(1920, 01, 01).AddDays(_rand.Next(20000)));

            data.Ssn = CreateRandomSSN(data.Birthday.ToDateTime());

            return (person, data);

        }
        public IEnumerable<(Person Person, PersonalData data)> CreatePersons(int count)
        {
            for (var i = 0; i < count; i++)
                yield return CreatePerson();
        }


        public string CreateRandomSSN(DateTime date)
        {
            int nr;
            int cd;

            while (true)
            {
                nr = _rand.Next(899) + 100;

                cd = SSNHelper.GetCheckDigit(nr.ToString("000"), date.ToString("ddMMyy"));

                if (cd >= 0 && cd <= 9)
                    break;
            }

            return SSNHelper.Format(string.Format("{0}{1}-{2:dd.MM.yy}", nr, cd, date));
        }

        public Staff CreateStaff()
        {
            var id = (_id++).ToString();

            var staff = new Staff
            {
                Id = id,
                FamilyName = _familynames[_rand.Next(_familynames.Length)],
                GivenName = _names[_rand.Next(_names.Length)]
            };

            return staff;
        }

        public IEnumerable<Staff> CreateStaffs(int count)
        {
            for (var i = 0; i < count; i++)
                yield return CreateStaff();
        }

        private ActivityType[] CreateRandomActivities()
        {
            var a = _activities[_rand.Next(_activities.Length)];

            if (string.IsNullOrEmpty(a)) return new ActivityType[0];

            return a.Split(',').Select(x => (ActivityType)int.Parse(x)).ToArray();
        }

        private IEnumerable<Activity> CreateRandomActivity(string personId, string staffId, LocalDate date)
        {
            var activities = CreateRandomActivities();

            foreach (var entry in activities.GroupBy(x => x))
            {
                yield return new Activity()
                {
                    StaffId = staffId,
                    PersonId = personId,
                    Date = date,
                    Amount = entry.Count(),
                    Type = entry.Key
                };
            }
        }

        public Activity[] CreateActivities(HkpvReport report)
        {
            var result = new List<Activity>();

            foreach (var staff in report.Staffs)
            {
                // die zu betreuenden Personen zufällig zuordnen
                var persons = report.Persons.Count == 1 || report.Staffs.Count == 1 ? report.Persons.ToArray() : report.Persons.Where(x => _rand.Next(report.Staffs.Count) == 0).ToArray();

                // ein Mitarbeiter soll pro Monat max. 6000 Minuten arbeiten. 
                // wenn nur wenige Personen betreut werden: max 500 Minuten pro Person
                var minuten = _rand.Next(Math.Min(persons.Count() * 500, 6000));

                while (minuten > 0)
                {
                    var personId = persons[_rand.Next(persons.Length)].Id;

                    var date = report.From.AddDays(_rand.Next(report.To.Day - report.From.Day + 1));

                    // Pro Tag, Person und Mitarbeiter nur ein Eintrag erlaubt:
                    if (!result.Where(x => x.PersonId == personId && x.StaffId == staff.Id && x.Date.Equals(date)).Any())
                    {
                        var a = CreateRandomActivity(personId, staff.Id, date).ToArray();

                        minuten -= a.Select(x => x.GetMinutes()).Sum();

                        result.AddRange(a);
                    }
                }
            }

            //sicherstellen, dass jede Person zumindest einen Eintrag hat
            foreach (var p in report.Persons.Where(x => !result.Where(a => a.PersonId == x.Id).Any()).ToArray())
            {
                var date = report.From.AddDays(_rand.Next(report.To.Day - report.From.Day + 1));

                result.AddRange(CreateRandomActivity(p.Id, report.Staffs[_rand.Next(report.Staffs.Count)].Id, date));
            }


            return result.ToArray();
        }
    }
}