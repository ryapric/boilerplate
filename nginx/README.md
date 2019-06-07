Demo for NGINX as a Reverse Proxy
=================================

This simple demo takes the [FREDcast
utility](https://www.github.com/ryapric/fredcast), and deploys it behind a
reverse proxy powered by [NGINX](https://www.nginx.com). Instead of hitting
FREDcast's `hostname:8080/api/fredcast` endpoint, you would instead simply hit
`hostname/fredcast`. In the local case here, the hostname is `localhost`
(`127.0.0.1`).

Requirements
------------

- [Docker]()

- [Docker Compose]()

- [GNU Make]()

How to Use
----------

1. Make sure you are in your terminal, at the top-level directory of this repo
   (e.g. `~/boilerplate/nginx`). This is the directory with both `Makefile` and
   `docker-compose.yaml`.

1. Run `make up`, and wait for the command to complete fully.

1. Using your favorite REST client (browser, Postman, `curl`, etc.), hit
   `http://localhost/fredcast`. You should see the same results as FREDcast
   usually generates, which includes support for its normal query strings (e.g.
   `localhost/fredcast?fred_id=UNRATE`).

1. To clean up the `docker-compose` environment, run `make down` from the same
   directory.
