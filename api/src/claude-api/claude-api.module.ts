import { Module } from '@nestjs/common';
import { ClaudeApiController } from './claude-api.controller';
import { ClaudeApiService } from './claude-api.service';

@Module({
  controllers: [ClaudeApiController],
  providers: [ClaudeApiService],
})
export class ClaudeApiModule {}
