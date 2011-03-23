using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace wdcodecheck
{
    class Program
    {
        static void Main(string[] args)
        {
            

            if (args.Length == 0)
            {
                Console.WriteLine("usage: wdcodecheck <path to wd.asm>");
                Environment.ExitCode = 1;

                return;
            }

            FileStream fs = new FileStream(args[0], FileMode.Open);
            StreamReader reader = new StreamReader(fs);
            int lastAddr = 0;
            int lineNumber = 0;

            Environment.ExitCode = 0;

            while (!reader.EndOfStream)
            {
                string line = reader.ReadLine();
                lineNumber++;

                if (line.IndexOf("exeAddr") == 0)
                {
                    int addr = 0;
                    if (!int.TryParse(line.Substring(8, line.Length - 9), System.Globalization.NumberStyles.HexNumber, null, out addr))
                    {
                        continue;
                    }

                    if (addr < lastAddr)
                    {
                        Console.WriteLine("bad addr at line {0}", lineNumber);
                        Environment.ExitCode = 1;
                    }
                    else
                    {
                        lastAddr = addr;
                    }
                }
            }
            reader.Close();
        }
    }
}
