import { $ } from "bun";
import assert from "node:assert";
import { isAbsolute } from "node:path";
import { parseArgs } from "node:util";

console.log(Bun.argv);
const { values, positionals } = parseArgs({
	args: Bun.argv.slice(2),
	options: {
		write: {
			type: "boolean",
			short: "w",
			default: false,
		},
	},
	strict: true,
	allowPositionals: true,
});

assert(
	positionals.length === 1,
	`You must pass exactly one positional argument, but got ${positionals.length} which are [${positionals.join(", ")}]`,
);

const abs_path = isAbsolute(positionals[0])
	? positionals[0]
	: `${process.cwd()}/${positionals[0]}`.replaceAll("/./", "/"); // this isn't perfect because /././ becomes /./, but I dont care

{
	const allowedFileTypes = ["image/png", "image/jpeg"];
	const file = Bun.file(abs_path);
	if (!file.exists()) {
		console.error(`File not found at ${abs_path}`);
		process.exit(1);
	}
	if (!allowedFileTypes.includes(file.type)) {
		console.error(
			`File at ${abs_path} is not one of allowed file types. expected png or jpeg, got ${file.type}`,
		);
		process.exit(1);
	}
}

await $`
#!/usr/bin/env bash

hyprctl hyprpaper preload "${abs_path}"
hyprctl hyprpaper wallpaper ",${abs_path}"

`;

if (values.write) {
	await $`ln -sf ${abs_path} ~/.config/wallpaper`;
}
