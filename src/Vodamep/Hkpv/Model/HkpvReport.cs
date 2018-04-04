﻿using System.Linq;

namespace Vodamep.Hkpv.Model
{
    public partial class HkpvReport
    {
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
    }
}