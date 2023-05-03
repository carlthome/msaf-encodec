import msaf
from encodec import EncodecModel
from encodec.utils import convert_audio

import torch
import torchaudio

audio_file = "data/audio/01-Sargon-Mindless.mp3"

# Segment audio file using.
boundaries, labels = msaf.process(audio_file)
print('Estimated boundaries:', boundaries)

# Save segments in MIREX format.
out_file = 'segments.txt'
print('Saving output to %s' % out_file)
msaf.io.write_mirex(boundaries, labels, out_file)

# Evaluate results.
evals = msaf.eval.process(audio_file)
print(evals)

# Instantiate a pretrained EnCodec model
model = EncodecModel.encodec_model_24khz()
model.set_target_bandwidth(6.0)

# Load and pre-process the audio waveform
wav, sr = torchaudio.load(audio_file)
wav = wav[None, 0, :]
wav = wav.unsqueeze(0)
wav = convert_audio(wav, sr, model.sample_rate, model.channels)

# Extract discrete codes from EnCodec
encoded_frames = model.encode(wav)
codes = torch.cat([encoded[0] for encoded in encoded_frames], dim=-1)
