# OpenProse System Workflow Plugin

A documentation-first, utilitarian plugin architecture for running, compiling, updating, and browsing `.prose` files. Built on top of the OpenClaw SDK ecosystem, this runtime delegates behavior to localized skill packs and maps virtual workflows directly to native OS primitives.

+--------------------------------------+OpenProse/prose help/prose run /prose compile /prose updateStatus: plugin enabledState: filesystem / sqlite / postgres+--------------------------------------+
## Features
- **Zero-Heavy Runtime:** System behavior is driven by markdown skill docs (`SKILL.md`) and declarative agent flows instead of heavy hardcoded conditional logic.
- **Dynamic Command Router:** Intercepts `/prose` intents directly through the OpenClaw SDK context.
- **Adaptive Persistence Stack:** Cascades elegantly across state backends: `PostgreSQL (Experimental)` -> `SQLite` -> `Local Filesystem`.

## Tech Stack & Configuration
- **Runtime & Language:** TypeScript / Node.js
- **SDK Targets:** `openclaw/plugin-sdk/plugin-entry`, `openclaw/plugin-sdk/core`

### Environment Variables
```bash
# Toggle experimental PostgreSQL persistence layer (Optional)
OPENPROSE_POSTGRES_URL="postgresql://user:password@localhost:5432/openprose"
Core Architecture Implementation1. Entrypoint & Registration (plugin.ts)TypeScriptimport { IPlugin, PluginContext, CommandRouteContext } from 'openclaw/plugin-sdk/core';
import { PluginEntry } from 'openclaw/plugin-sdk/plugin-entry';
import { StateManager } from './state';
import { WorkflowEngine } from './engine';

export class OpenProsePlugin implements IPlugin {
    public readonly name = 'open-prose';
    public readonly version = '1.0.0';
    private stateManager!: StateManager;
    private workflowEngine!: WorkflowEngine;

    async onEnable(ctx: PluginContext): Promise<void> {
        // Initialize fallback-safe state layer
        this.stateManager = new StateManager(process.env.OPENPROSE_POSTGRES_URL);
        await this.stateManager.initialize();

        // Initialize execution engine mapping primitives
        this.workflowEngine = new WorkflowEngine(this.stateManager, ctx);

        // Register Command Route
        ctx.registerCommand('/prose', async (routeCtx: CommandRouteContext) => {
            await this.handleCommand(routeCtx);
        });

        ctx.logger.info("OpenProse Workflow System Plugin Successfully Enabled.");
    }

    private async handleCommand(ctx: CommandRouteContext): Promise<void> {
        const args = ctx.arguments || [];
        const subCommand = args[0]?.toLowerCase();

        try {
            switch (subCommand) {
                case 'help':
                    await this.workflowEngine.executeHelp(ctx);
                    break;
                case 'run':
                    if (!args[1]) throw new Error("Missing file path argument.");
                    await this.workflowEngine.executeRun(args[1], ctx);
                    break;
                case 'compile':
                    if (!args[1]) throw new Error("Missing target file compilation path.");
                    await this.workflowEngine.executeCompile(args[1], ctx);
                    break;
                case 'update':
                    await this.workflowEngine.executeUpdate(ctx);
                    break;
                default:
                    await ctx.reply("Unknown sub-command. Run `/prose help` to see valid workflows.");
            }
        } catch (error: any) {
            ctx.logger.error(`Execution error inside /prose routing: ${error.message}`);
            await ctx.reply(`❌ Error: ${error.message}`);
        }
    }

    async onDisable(): Promise<void> {
        await this.stateManager.close();
    }
}

// Export registration handle for OpenClaw dynamic loader
PluginEntry.register(new OpenProsePlugin());
2. State Abstraction Layer (state.ts)TypeScriptimport * as fs from 'fs/promises';
import * as path from 'path';

export interface IStateProvider {
    save(key: string, data: string): Promise<void>;
    read(key: string): Promise<string | null>;
}

export class StateManager {
    private provider!: IStateProvider;

    constructor(private pgUrl?: string) {}

    async initialize(): Promise<void> {
        // Cascading Fallback Strategy: Postgres -> SQLite -> Filesystem
        if (this.pgUrl) {
            try {
                const { PostgresProvider } = await import('./providers/postgres');
                this.provider = new PostgresProvider(this.pgUrl);
                await (this.provider as any).connect();
                return;
            } catch (e) {
                console.warn("⚠️ Postgres connection failed, dropping down to SQLite tier...");
            }
        }

        try {
            const { SQLiteProvider } = await import('./providers/sqlite');
            this.provider = new SQLiteProvider();
            await (this.provider as any).connect();
        } catch (e) {
            console.warn("⚠️ SQLite initialization failed. Utilizing Local Filesystem fallback.");
            this.provider = new FilesystemProvider();
        }
    }

    async save(key: string, data: string) { return this.provider.save(key, data); }
    async read(key: string) { return this.provider.read(key); }
    async close() { if ((this.provider as any).disconnect) await (this.provider as any).disconnect(); }
}

class FilesystemProvider implements IStateProvider {
    private baseDir = path.join(process.cwd(), '.openprose_data');
    async save(key: string, data: string): Promise<void> {
        await fs.mkdir(this.baseDir, { recursive: true });
        await fs.writeFile(path.join(this.baseDir, `${encodeURIComponent(key)}.json`), data, 'utf-8');
    }
    async read(key: string): Promise<string | null> {
        try {
            return await fs.readFile(path.join(this.baseDir, `${encodeURIComponent(key)}.json`), 'utf-8');
        } catch { return null; }
    }
}
