# log4r 0.3.2 (2020-01-17)

* Fixes an issue where appender functions did not evaluate all their arguments,
  leading to surprising behaviour in e.g. loops. Reported by Nicola Farina.

# log4r 0.3.1 (2019-09-04)

* There is now a vignette on logger performance.
* Fixes a missing header file on older versions of R (<= 3.4). (#12)
* Fixes an issue where `default_log_layout()` would not validate format strings
  correctly.

# log4r 0.3.0 (2019-06-20)

* A new system for configuring logging, via "Appenders" and "Layouts". See
  `?logger`, `?appenders`, and `?layouts` for details.
* Various fixes and performance improvements.
* New maintainer: Aaron Jacobs (atheriel@gmail.com)

# log4r 0.2 (2014-09-29)

* Same as v0.1-5.

# log4r 0.1-5 (2014-09-28)

* New maintainer: Kirill Müller (krlmlr+r@mailbox.org)
* Log levels are now objects of class `"loglevel"`, access to the hidden
  constants, e.g., `log4r:::DEBUG`, is deprecated (#4).
