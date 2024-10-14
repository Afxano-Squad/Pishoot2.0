# Mini Challenge 2 - Pishoot

## Git Flow Rule

### Important Branch

Branch `development` adalah default branch. Setiap kali developer ingin membuat branch baru yang ter-update, **_maka wajib membuat dari branch development sebagai source_**

### Branch Naming

Ada 4 tipe penamaan branch, yaitu `feature`, `fixing`, `hot-fix`, dan `docs`.

- `feature` digunakan untuk branch yang tujuannya untuk pembuatan fitur baru.

- `fixing` digunakan untuk branch yang tujuannya untuk memperbaiki issue/bug yang major.

- `hot-fix` digunakan untuk branch yang tujuannya untuk memperbaiki issue/bug yang minor.

- `docs` digunakan untuk branch yang tujuannya untuk merubah dokumentasi (readme).

```
Contoh:
- feature/login //branch untuk fitur login
- fixing/login //branch untuk memperbaiki issue/bug major di fitur login
- hot-fix/login //branch untuk memperbaiki issue/bug minor di fitur login
- docs/commit-rule //branch untuk merubah dokumentasi terkait commit rule
```

### Merge Branch

Untuk melakukan merge antar branch, maka dilakukan dengan menggunakan fitur pull request (PR) yang disediakan oleh github. Lebih jauh tentang pembuatan pull request bisa cek [disini](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

### Commit Rule

Berikan pesan commit dengan template berikut:
`type(scope): message`

- `type`:
  - `feat`: jika yang dilakukan ada membuat fitur baru.
  - `fix`: jika yang dilakukan adalah fixing major bug.
  - `hot-fix`: jika yang dilakukan adalah fixing minor bug.
  - `docs`: jika yang dilakukan adalah update readme.
- `scope`: mendeskripsikan bagian yang terkena dampak perubahan code.
- `message`: pesan commit secara singkat yang mendeskripsikan perubahan yang dilakukan.

```
Contoh:
- feat(History): add thumbnail history
- feat(drawing): add drawing feature
- docs(main readme): update folder structure
```
