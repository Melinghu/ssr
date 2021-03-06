// Usage example for the MimoProcessor reading from and writing to multichannel
// audio files.

#include "apf/mimoprocessor_file_io.h"

// First the policy ...
#include "apf/pointer_policy.h"
// ... then the SimpleProcessor.
#include "simpleprocessor.h"

int main(int argc, char *argv[])
{
  const size_t blocksize = 65536;

  if (argc < 4)
  {
    std::cerr << "Error: too few arguments!" << std::endl;
    std::cout << "Usage: " << argv[0]
      << " infilename outfilename outchannels [threads]" << std::endl;
    return 42;
  }

  std::string infilename = argv[1];
  std::string outfilename = argv[2];

  apf::parameter_map e;
  if (argc >= 5)
  {
    e.set("threads", argv[4]);
  }

  SndfileHandle in(infilename, SFM_READ);
  e.set("in_channels", in.channels());
  e.set("out_channels", apf::str::S2RV<int>(argv[3]));

  e.set("block_size", blocksize);
  e.set("sample_rate", in.samplerate());

  SimpleProcessor engine(e);

  return mimoprocessor_file_io(engine, infilename , outfilename);
}
