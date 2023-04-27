import msaf

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
