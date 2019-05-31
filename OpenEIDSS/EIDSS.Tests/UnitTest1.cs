using System;
using EIDSS.Client.API_Clients;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;

namespace EIDSS.Tests
{
    [TestClass]
    public class ServiceClientTests
    {
        HumanServiceClient hs = new HumanServiceClient();
        CrossCuttingServiceClient xs = new CrossCuttingServiceClient();
        OutbreakServiceClient osc = new OutbreakServiceClient();
        VeterinaryServiceClient vs = new VeterinaryServiceClient();
        AccountServiceClient accs = new AccountServiceClient();

        [TestMethod]
        public void OmmVetCaseGetDetailAsyncTest()
        {
            var result = osc.OmmVetCaseGetDetailAsync(new OmmCaseGetDetailParams
            {
                langId = "en",
                OutbreakCaseReportUID = 147
            }).Result;

            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void RegisterUser()
        {
            accs.Register(new Client.Requests.UserRegistrationInfo
            {
                UserName = "xxxxxxxx",
                Password = "BatMan 1$",
                ConfirmPassword = "Batman 1$",
                Email = "",
                idfUserID = 55541630000015

            });


        }



        [TestMethod]
        public void CountryGet()
        {
            var x = xs.GetCountry(140000000);
            Assert.IsNotNull(x);
        }


        [TestMethod]
        public void CountryGetListTest()
        {
            var list = xs.GetCountryListAsync("en-US").Result;

            Assert.IsNotNull(list);
        }

        [TestMethod]
        public void HumanActiveSurveillanceGetDetails()
        {
            var list = hs.HumanActiveSurveillanceGetDetail("en-us", 1).Result;
            Assert.IsNotNull(list);
        }

        [TestMethod]
        public void HumanGetList()
        {
            HumanGetListParams parms = new HumanGetListParams();
            parms.FirstOrGivenName = "a";


            var list = hs.GetHumanListAsync(parms).Result;

            Assert.IsNotNull(list);
        }

        [TestMethod]
        public void FlexibleFormsReferenceTypesAsync()
        {
            var list = xs.GetFlexibleFormsReferenceTypesAsync("en-US").Result;
            Assert.IsNotNull(list);
        }

        [TestMethod]
        public void OMMSessionNoteSet()
        {
            OMMSessionNoteSetParams parms = new OMMSessionNoteSetParams
            {
                langId = "en",
                strNote = "Steven Test",
                idfOutbreakNote = 7,
                idfPerson = 3449750000000,
                idfOutbreak = 176,
                intRowStatus = 0

            };
            var result = osc.OmmSessionNoteSet(parms);

            Assert.IsNotNull(result);

        }

        [TestMethod]
        public void SetHumanDiseaseTest()
        {
            DateTime actionDate = new DateTime(2018, 12, 24);
            HumanDiseaseSetParams parms = new HumanDiseaseSetParams
            {
                idfHumanCase = 14,
                idfHuman = 18,
                idfHumanActual = 15,
                strHumanCaseId = "H0000180014",
                idfsFinalDiagnosis = 784050000000,
                datDateOfDiagnosis = actionDate,
                datNotificationDate = actionDate,
                idfsYNPreviouslySoughtCare = 10100002,
                idfsYNHospitalization = 10100002,
                idfsCaseProgressStatus = 10109001,
                idfsYNSpecimenCollected = 10100002,
                DiseaseReportTypeID = 4578940000002,
                dateofClassification = actionDate
            };

            var result = hs.SetHumanDisease(parms);
        }

        [TestMethod]
        public void GetFarmDetailTest()
        {
            // var result = vs.GetFarmDetailAsync("en", true, 10, null).Result;
        }
    }
}
