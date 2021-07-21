+++
draft = false
slug = "k8s-postgres-backups"
title = "Postgres with backups on Kubernetes"
date = "2021-07-21"
+++

I think Kubernetes is straight forward to operate—at least at a trivial to moderate scale.

If you’re a seasoned Linux sysadmin, Kubernetes is just another layover on your educational pilgrimage. Maybe you don’t need it, but if it has already piqued your interest you may as well go ahead and explore what it has to offer.

If you consider yourself a sysadmin newbie, then you’d be better served learning the foundational concepts Kubernetes abstracts. But learning Kubernetes is certainly not out of reach.

I (kinda) recently migrated my personal stack to Terraform + Kubernetes in search of a declarative panacea. I ditched homebrew for nix too, but that’s for another post.

So far, so good.

Part of the migration included launching database instances for my projects, and because I consider myself a responsible human, they needed to have backups.  I thought about using a generic cloud provider to host my databases—but I love self hosting too much; I also considered deploying a third-party k8s operator—but they brought too much complexity.

Instead I turned to the basics (haha…): the official postgres container, coupled with k8s cron jobs that run `pg_dump`, compressed and encrypted with restic, then sent over to Wasabi for storage.

Backblaze B2 seems like the go-to if you're looking for storage that isn't provided by "Big Cloud", but I rolled with Wasabi because B2 API calls are an additional cost to storage. With multiple projects running frequent backups hitting the `ListObjects` endpoint, the cost racks up quickly. Wasabi's API calls are, within reason, included in the flat monthly rate if you stay under 1TB of storage.

Restic is a fantastic backup tool that I use for everything I can. It has great CLI ergonomics, a speedy and robust feature set, and I'm assured the security is top-notch.

All of the manifests I use are publically available. They'll need some tweaking for your cluster, but they're almost entirely generic. There are five prominent changes to make:

* The name of your database in `database.yaml`;
* `DATABASE_URL` in `backup.yaml`;
* I do encrypt my secrets. You'll need to remove all the `sops` keys and fill in your own secrets;
* Cron frequency dependent on your risk tolerance.
* CronJob `spec.suspend` key should be `false` (or removed entirely) otherwise they won't run

Here's a dump of all the manifests to run the database:

1. A [`PersistentVolumeClaim`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/pvc.yaml) to reserve storage on a node
2. A [`Secret`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/postgres-auth.yaml) for postgres credentials
3. A [`Deployment`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/database.yaml) to… deploy the database
4. A [`Service`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/service.yaml) to expose the database in the cluster

And here are all the manifests for backups:

1. A [`Secret`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/backups/storage-credentials.yaml) for Wasabi (or B2, S3, GCP Storage…) credentials
2. A [`Secret`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/backups/repository-credentials.yaml) for encrypting the backup repository
3. A [`CronJob`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/backups/backup.yaml) to run the dump and backup to Wasabi
4. A [`CronJob`](https://git.sr.ht/~sbaildon/cluster/tree/a8baba7c/item/projects/crave_supply/database/backups/prune.yaml)—optional, but recommended—to prune old backups

## A word of warning
No backups are kept in the cluster, and that makes Wasabi a single point of failure. As always, send copies to different locations if preserving the data is imperative for your sanity.

