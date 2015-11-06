using System;
using System.Security.Cryptography;
using System.Text;
namespace EM_Report.BLL.Commons
{
    public class CryptMD5
    {
        // Check to see if the given password and salt hash to the same value
        // as the given hash.
        public static bool IsMatchingHash(string password, string salt, string hash)
        {
            // Recompute the hash from the given auth details, and compare it to
            // the hash provided by the cookie.
            return EncryptMD5WithSalt(password, salt) == hash;
        }

        // Create a hash of the given password and salt.
        public static string EncryptMD5WithSalt(string password, string salt)
        {
            // Get a byte array containing the combined password + salt.
            string authDetails = password + salt;
            byte[] authBytes = System.Text.Encoding.ASCII.GetBytes(authDetails);

            // Use MD5 to compute the hash of the byte array, and return the hash as
            // a Base64-encoded string.
            var md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] hashedBytes = md5.ComputeHash(authBytes);
            string hash = Convert.ToBase64String(hashedBytes);
            return hash;
        }

        public static Byte[] EncryptMD5(string inputText)
        {
            //create the MD5CryptoServiceProvider object we will use to encrypt the password
            MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();
            //create an array of bytes we will use to store the encrypted password

            //Create a UTF8Encoding object we will use to convert our password string to a byte array
            UTF8Encoding encoder = new UTF8Encoding();

            //encrypt the password and store it in the hashedBytes byte array
            return md5Hasher.ComputeHash(encoder.GetBytes(inputText));
        }
    }
}