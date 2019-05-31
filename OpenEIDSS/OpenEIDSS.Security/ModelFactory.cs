using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Caching;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Security
{
    public sealed class ModelFactory
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ModelFactory));

        static private EIDSSRepository _repository = new Data.EIDSSRepository();

        public static ObjectCache RoleCache = MemoryCache.Default;

        static CacheItemPolicy expiry = new CacheItemPolicy
        {
            Priority = CacheItemPriority.Default,
            AbsoluteExpiration = DateTimeOffset.Now.AddHours(4) // This matches the token expiry...
        };

        public ModelFactory()
        {
        }

        /// <summary>
        /// Retrieve details about the given user.
        /// </summary>
        /// <param name="userid"></param>
        /// <returns></returns>
        public static AspNetUserGetDetailModel GetUserDetail(string userid)
        {
            List<AspNetUserGetDetailModel> result = new List<AspNetUserGetDetailModel>();
            try
            {
                log.Info("GetUserDetail is called");
                result = _repository.AspNetUserGetDetail(userid);

                if (result == null || result.Count == 0)
                    return new AspNetUserGetDetailModel();
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetUserDetail Procedure: " + ex.Procedure, ex);
                throw ex;
            }
            catch (Exception ex)
            {
                log.Error("GetUserDetail failed", ex);
                throw ex;
            }

            return result.FirstOrDefault();

        }

        /// <summary>
        /// Retrieves the roles and permissions for the given user.  The system first checks the roles cache for the existence of the collection and if not found,
        /// queries the database and commits to cache.
        /// </summary>
        /// <param name="idfUserId"></param>
        /// <param name="cacheKey">User account name, which is used as the cache key.</param>
        /// <returns></returns>
        public static List<AspNetUserGetRolesAndPermissionsModel> GetUserRolesAndPermissions(long idfUserId, string cacheKey )
        {
            List<AspNetUserGetRolesAndPermissionsModel> result = new List<AspNetUserGetRolesAndPermissionsModel>();

            try
            {
                log.Info("GetUserRolesAndPermissions is called");
                
                result = RoleCache.Get(cacheKey) as List<AspNetUserGetRolesAndPermissionsModel>;

                if (result == null)
                {
                    result = _repository.AspNetUserGetRolesAndPermissions(idfUserId);

                    if (result == null || result.Count == 0)
                        return new List<AspNetUserGetRolesAndPermissionsModel>();

                    // set the cache...
                    if (result != null && result.Count > 0)
                        RoleCache.Set( cacheKey, result, expiry );
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL error in GetUserRolesAndPermissions: " + ex.Procedure, ex);
                throw ex;
            }
            catch (Exception ex)
            {
                log.Error("GetUserRolesAndPermissions failed", ex);
                throw ex;
            }
            return result;
        }

    }
}


