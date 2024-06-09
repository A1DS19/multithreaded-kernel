#include "streamer.h"
#include "memory/heap/kheap.h"
#include "config.h"

struct disk_stream* disk_streamer_new(int disk_id)
{
  struct disk *disk = disk_get_disk(disk_id);
  if (!disk)
  {
    return NULL;
  }

  struct disk_stream* streamer = kzalloc(sizeof(struct disk_stream));
  streamer->disk = disk;
  streamer->pos = 0;
  return streamer;
}

int disk_streamer_seek(struct disk_stream* stream, int pos)
{
  stream->pos = pos;
  return 0;
}

int disk_streamer_read(struct disk_stream* stream, void* out, int total)
{
  int sector = stream->pos / OS_SECTOR_SIZE;
  int offset = stream->pos % OS_SECTOR_SIZE;
  char buf[OS_SECTOR_SIZE];

  int res = disk_read_block(stream->disk, sector, 1, buf);
  if (res < 0)
  {
    goto out;
  }

  int total_to_read = total > OS_SECTOR_SIZE ? OS_SECTOR_SIZE : total;
  for (int i = 0; i < total_to_read; i++)
  {
    *(char*)out++ = buf[offset + i];
  }

  stream->pos += total_to_read;
  if (total > OS_SECTOR_SIZE)
  {
    res = disk_streamer_read(stream, out, total - OS_SECTOR_SIZE);
  }

out:
  return res;
}

void disk_streamer_close(struct disk_stream* stream)
{
  kfree(stream);
}