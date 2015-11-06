using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace MergeSQLs
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var path = args[0].ToString();                
                var pathFileName = args[1].ToString();
                var fileName = args[2].ToString();

                if (string.IsNullOrEmpty(path) || string.IsNullOrEmpty(pathFileName) || string.IsNullOrEmpty(fileName)) 
                {
                    Console.WriteLine("Please input [SQL Folder], [SQL Path File], [SQL File Name] .........");
                    Console.Read(); 
                }

                string resultFile = Path.Combine(pathFileName, fileName);
                if (File.Exists(resultFile))
                {
                    File.Delete(resultFile);
                }
                var files = Directory.GetFiles(path, "*.sql");
                StringBuilder sb = new StringBuilder();
                foreach (var filename in files)
                {
                    // Open the file into a StreamReader
                    StreamReader file = File.OpenText(filename);
                    // Read the file into a string
                    sb.Append(file.ReadToEnd().Replace('‘','\''));
                    // Close the file so it can be accessed again.
                    file.Close();
                    // Add a single line
                    sb.AppendLine();
                    sb.AppendLine("/********************************/");
                }
                using (var outfile =  new StreamWriter(resultFile))
                {
                    outfile.Write(sb.ToString());
                }
                
            }
            catch (IOException ex)
            {
                Console.WriteLine(ex.Message);
            }
            //Console.WriteLine("Press any key to close the window...");
            //Console.Read();
        }
    }
}
