// Code is copied from: https://dobon.net/vb/dotnet/file/getabsolutepath.html
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Runtime.InteropServices;

namespace mk_rel_path
{
    class Program
    {
        [DllImport("shlwapi.dll",
            CharSet = CharSet.Auto)]
        private static extern bool PathRelativePathTo(
             [Out] StringBuilder pszPath,
             [In] string pszFrom,
             [In] System.IO.FileAttributes dwAttrFrom,
             [In] string pszTo,
             [In] System.IO.FileAttributes dwAttrTo
        );

        /// <summary>
        /// Usage: mk_rel_path "basePath" "absolutePath"
        /// Example: mk_rel_path "c:\abc" c:\test.txt
        /// Example's Output: ..\test.txt
        /// Information: In case of error, "[ERROR]" is included in the console output,
        /// and the return value of this program will be -1. If succeeded, zero will be returned.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        static int Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.Write("[ERROR] Command: mk_rel_path \"basePath\" \"absolutePath\"");
                return -1;
            }


            string basePath = args[0];
            string absolutePath = args[1];

            Console.Write(GetRelativePath(basePath, absolutePath));
            
            return 0;
        }

        /// <summary>
        /// 絶対パスから相対パスを取得する
        /// </summary>
        /// <param name="basePath">基準とするフォルダのパス</param>
        /// <param name="absolutePath">相対パスを取得したいパスの絶対パス</param>
        /// <returns>絶対パス。</returns>
        private static string GetRelativePath(string basePath, string absolutePath)
        {
            StringBuilder sb = new StringBuilder(260);
            bool res = PathRelativePathTo(sb,
                basePath, System.IO.FileAttributes.Directory,
                absolutePath, System.IO.FileAttributes.Normal);
            if (!res)
            {
                throw new Exception("相対パスの取得に失敗しました。");
            }
            return sb.ToString();
        }
    }
}
