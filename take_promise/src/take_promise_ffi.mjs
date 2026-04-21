export async function with_stdout(fn) {
  const chunks = [];
  const origLog = console.log;
  const origWrite = process.stdout.write.bind(process.stdout);
  console.log = (...args) => { chunks.push(args.join(" ") + "\n"); };
  process.stdout.write = (chunk) => { chunks.push(chunk.toString()); return true; };
  try {
    const result = await fn();
    return [result, chunks.join("")];
  } finally {
    console.log = origLog;
    process.stdout.write = origWrite;
  }
}

export async function with_stderr(fn) {
  const chunks = [];
  const origError = console.error;
  const origWrite = process.stderr.write.bind(process.stderr);
  console.error = (...args) => { chunks.push(args.join(" ") + "\n"); };
  process.stderr.write = (chunk) => { chunks.push(chunk.toString()); return true; };
  try {
    const result = await fn();
    return [result, chunks.join("")];
  } finally {
    console.error = origError;
    process.stderr.write = origWrite;
  }
}
