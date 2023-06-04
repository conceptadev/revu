import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClaudeApiModule } from './claude-api/claude-api.module';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

export const PUBLIC_FOLDER_NAME = 'public';
export const PUBLIC_PATH = `./${PUBLIC_FOLDER_NAME}`;
export const PUBLIC_URL = `/${PUBLIC_FOLDER_NAME}`;

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', PUBLIC_FOLDER_NAME),
      serveRoot: PUBLIC_URL,
    }),
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ClaudeApiModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
