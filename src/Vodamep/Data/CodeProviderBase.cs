﻿using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Vodamep.Data
{

    public abstract class CodeProviderBase
    {
        private static Regex _commentPattern = new Regex("//.*$");
        private readonly IDictionary<string, string> _dict = new SortedDictionary<string, string>();
        protected CodeProviderBase()
        {
            this.Init();
        }

        public abstract string Unknown { get; }

        public bool IsValid(string code) => _dict.ContainsKey(code ?? string.Empty);

        private void Init()
        {
            var assembly = this.GetType().Assembly;
            var resourceStream = assembly.GetManifestResourceStream($"{assembly.GetName().Name}.{this.ResourceName}");

            using (var reader = new StreamReader(resourceStream))
            {
                while (!reader.EndOfStream)
                {
                    var line = reader.ReadLine();

                    line = _commentPattern.Replace(line, string.Empty).Trim();

                    if (string.IsNullOrEmpty(line))
                        continue;

                    var values = line.Split(';');
                    _dict.Add(values[0], values[1]);
                }
            }
        }

        public IEnumerable<string> GetCSV() => _dict.Select(x => $"{x.Key};{x.Value}");

        protected abstract string ResourceName { get; }

        public static CodeProviderBase GetInstance<T>()
            where T : CodeProviderBase
        {
            CodeProviderBase result = null;
            try
            {
                result = (CodeProviderBase)typeof(T).GetProperty("Instance", System.Reflection.BindingFlags.Static | System.Reflection.BindingFlags.Public).GetValue(null);
            }
            catch
            {
                throw new System.Exception($"CodeProviderBase.GetInstance<{typeof(T).Name}> failed!");
            }

            return result;

        }
    }
}
