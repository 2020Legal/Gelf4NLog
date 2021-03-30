using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TestLogovaniDoGraylogu
{
    class Program
    {
        static void Main(string[] args)
        {
            var logger = LogManager.GetLogger("TestLogovaniDoGraylogu") as ILogger;

            bool quit = false;
            int mi = 1;

            var tasksCount = Environment.ProcessorCount;
            Task[] tasks = new Task[tasksCount];

            for (int i = 0; i < tasks.Length; i++)
            {
                tasks[i] = Task.Run(new Action(() =>
                {
                    while (!quit)
                    {
                        Interlocked.Increment(ref mi);
                        logger.Info($"TEST logovací zpráva {mi} {Thread.CurrentThread.ManagedThreadId}");
                    }
                }));
            }

            logger.Warn("Press any key for exit...");
            Console.ReadKey();
            quit = true;
            logger.Info("Waiting for exit...");
            Task.WaitAll(tasks);
        }
    }
}
