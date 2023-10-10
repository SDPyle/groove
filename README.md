# Groove

A groovy open source SCRUM application utilizing the STAPLE stack:

- Surface UI
- Tailwind CSS
- Ash
- Phoenix
- LiveView
- Elixir

In addition to some basic SCRUM functionality, users can indicate what they are working on and every client is updated in real time; giving the app a fun sense of teamwork.
![Screenshot from 2023-10-09 15-38-50](https://github.com/SDPyle/groove/assets/7622818/dc39cbc6-0032-49e6-9a43-23f7856f91af)
![Screenshot from 2023-10-09 15-41-38](https://github.com/SDPyle/groove/assets/7622818/114e7a9e-2e26-4f1c-b69e-0cacd4db639d)

## Desired Feature Set

### Completed

- [x] Account creation & login
- [x] Create & edit user stories
- [x] Users can start working on user stories
- [x] Users can start working on the backlog
- [x] Show all users currently working on front page
- [x] Show all users currently working on a user story
- [x] Show all users currently working on the backlog
- [x] Markdown rendering for user story description

### Desired

- [ ] Invite only
- [ ] Sprints
- [ ] Per user permissions (read/write user stories)
- [ ] Show work history for user
- [ ] Show work history for user story
- [ ] Users can comment on work items
- [ ] Archive work shifts by a chron job or admin action (such as after a sprint perhaps)
- [ ] Custom work types beyond backlog & features

# Setup

## Interactive

### Prerequisites

- Elixir 1.14. asdf (https://asdf-vm.com/) is useful for Elixir setup and management.
- Postgres. Example using Docker:

```
docker run --name pg -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres
```

### Setup

Get the dependencies.

```
mix deps.get
```

Setup the database.

```
mix ash_postgres.create
mix ash_postgres.migrate
```

### Run

```
iex -S mix phx.server
```

After registering, you will need to check the logs for the email verification link, or go to http://localhost:4000/dev/mailbox.

After verifying your email, you must complete your profile before accessing the rest of the application.

## Local Cluster with Docker Compose

### Prerequisites

- Docker

### Setup

```
mix deps.get
```

```
mix phx.gen.release
```
```
mix
```
```
echo "SECRET_KEY_BASE=$(mix phx.gen.secret)" > .env
```

### Run

```
docker compose up --build
```

After registering, you will need to check the logs for the email verification link.

After verifying your email, you must complete your profile before accessing the rest of the application.

# Credits

## UI Kit

https://www.creative-tim.com/product/soft-ui-dashboard-tailwind

MIT License

Copyright (c) 2017 Creative Tim

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
