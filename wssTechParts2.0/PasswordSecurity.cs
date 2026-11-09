using System;
using System.Security.Cryptography;

namespace wssTechParts2._0
{
    internal static class PasswordSecurity
    {
        private const int Iterations = 600000;
        public static string Hash(string password)
        {
            if (string.IsNullOrWhiteSpace(password) || password.Length < 12 || password.Length > 128)
                throw new ArgumentException("La contraseña debe tener entre 12 y 128 caracteres.");
            byte[] salt = new byte[16];
            using (var random = RandomNumberGenerator.Create()) random.GetBytes(salt);
            using (var derive = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256))
                return "pbkdf2-sha256$" + Iterations + "$" + Convert.ToBase64String(salt) + "$" + Convert.ToBase64String(derive.GetBytes(32));
        }

        public static bool Verify(string password, string encoded)
        {
            if (password == null || password.Length > 128 || encoded == null) return false;
            try
            {
                string[] parts = encoded.Split('$');
                int iterations;
                if (parts.Length != 4 || parts[0] != "pbkdf2-sha256" ||
                    !int.TryParse(parts[1], out iterations) || iterations < 100000 || iterations > 1000000) return false;
                byte[] salt = Convert.FromBase64String(parts[2]);
                byte[] expected = Convert.FromBase64String(parts[3]);
                if (salt.Length != 16 || expected.Length != 32) return false;
                using (var derive = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
                {
                    byte[] actual = derive.GetBytes(32);
                    int difference = 0;
                    for (int i = 0; i < actual.Length; i++) difference |= actual[i] ^ expected[i];
                    return difference == 0;
                }
            }
            catch (FormatException) { return false; }
        }
    }
}
