How To: Generate Entropy
========================

:date: 2016-02-20
:tags: linux, entropy, random
:category: Linux
:lang: en
:summary: A walkthrough on the available solutions for feeding the kernel with
          some entropy.

Sometimes you need to generate some entropy.

There are both *hardware* and *software* solutions:

- **Hardware solutions**:
  They can *generate more entropy per second*, but you need physical access.
- **Software solutions**:
  They have less performance, but you just need ``root`` permissions
  (no physical access).

Hardware solutions
------------------

Typically it's a (USB) device that *generates and streams some random numbers*.

One of such devices is `TrueRNG`_ (price is approx: 50$).

.. _`TrueRNG`: http://ubld.it/products/truerng-hardware-random-number-generator

Software solutions
------------------

RNGD
~~~~

*This program feeds random data from hardware device to kernel*.

.. code-block:: shell-session

   # rngd -r /dev/urandom

- `Man`_

.. _`Man`: http://linux.die.net/man/8/rngd

Audio Entropy Daemon
~~~~~~~~~~~~~~~~~~~~

*This program feeds the* ``/dev/random`` *device with entropy-data read from
an audio device*.

The audio-data is not copied as is but first 'de-biased' and analysed to
determine how much bits of entropy is in it.

- `Official Website`_

.. _`Official website`: https://www.vanheusden.com/aed
