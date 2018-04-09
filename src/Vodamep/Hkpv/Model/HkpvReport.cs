﻿using Google.Protobuf;
using System;
using System.Linq;
using System.Security.Cryptography;

namespace Vodamep.Hkpv.Model
{
    public partial class HkpvReport
    {
        public DateTime FromD { get => this.From.AsDate(); set => this.From = value.AsValue(); }

        public DateTime ToD { get => this.To.AsDate(); set => this.To = value.AsValue(); }

        public HkpvReport AsSorted()
        {
            var result = new HkpvReport()
            {
                Institution = this.Institution,
                From = this.From,
                To = this.To
            };

            result.Activities.AddRange(this.Activities.OrderBy(x => x));
            result.OtherActivities.AddRange(this.OtherActivities.OrderBy(x => x));
            result.Consultations.AddRange(this.Consultations.OrderBy(x => x));

            result.Persons.AddRange(this.Persons.OrderBy(x => x.Id));
            result.PersonalData.AddRange(this.PersonalData.OrderBy(x => x.Id));
            result.Staffs.AddRange(this.Staffs.OrderBy(x => x.Id));

            return result;
        }

        public string GetId()
        {
            using (var s = SHA256.Create())
            {
                var h = s.ComputeHash(this.ToByteArray());
                                
                var hash = System.Net.WebUtility.UrlEncode(Convert.ToBase64String(h));

                var date = this.FromD;

                return $"{this.Institution.Id}_{date.Year}_{date.Month}_{hash}";
            }
        }
    }
}