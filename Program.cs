using LibVLCSharp.Shared;
using System;
using System.IO;
using System.Reflection;

namespace RadioRecorderLibVlcSharp
{
    class Program
    {
        static void Main(string[] args)
        {
            // Record in a file "record.ts" located in the bin folder next to the app
            var currentDirectory = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
            var destination = Path.Combine(currentDirectory, "record.ts");

            // Load native libvlc library
            Core.Initialize();

            using (var libvlc = new LibVLC())
            //var libvlc = "/usr/lib/x86_64-linux-gnu/";
            using (var mediaPlayer = new MediaPlayer(libvlc))
            {
                // Redirect log output to the console
                //linha abaixo dando erro no linux, pois está usando biblioteca msvcrt, do windows.
                //libvlc.Log += (sender, e) => Console.WriteLine($"[{e.Level}] {e.Module}:{e.Message}");                

                // Create new media with HLS link             
                var urlRadio = "http://playerservices.streamtheworld.com/api/livestream-redirect/JBFMAAC1.aac";
                var media = new Media(libvlc, urlRadio, FromType.FromLocation);                

                // Define stream output options. 
                // In this case stream to a file with the given path and play locally the stream while streaming it.
                media.AddOption(":sout=#file{dst=" + destination + "}");
                media.AddOption(":sout-keep");

                // Start recording
                mediaPlayer.Play(media);

                //realiza o parse, para descobrir o RDS (quando aplicável)
                media.Parse(MediaParseOptions.ParseNetwork);

                //configura evento para recuperar dados do RDS
                media.MetaChanged += (sender, e) => {
                    Console.WriteLine($"{DateTime.Now.ToString()} - {media.Meta(MetadataType.NowPlaying)}");                
                };

                Console.WriteLine($"Recording in {destination}");
                Console.WriteLine("Press any key to exit");
                Console.ReadKey();
            }
        }

    }
}
